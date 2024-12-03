import UIKit
import ProgressHUD
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

final class AuthViewController: UIViewController {
    var callback: Callback?
    private let store = AuthStore()
    private var bag = Bag()
    
    private var isLoading = false { didSet { self.actionButton.setNeedsUpdateConfiguration()}}
    private var isLogin = true { didSet { self.updateUI()}}
    
    private let emailTextField = AuthTextField(placeholder: "Email", keyboardType: .emailAddress)
    private let passwordTextField = AuthTextField(placeholder: "Password", isSecureTextEntry: true)
    private let repeatPasswordTextField = AuthTextField(placeholder: "Repeat Password", isSecureTextEntry: true)
    private let actionButton = UIButton(type: .system)
    
    private let rootStackView = UIStackView()
    
    init(callback: Callback? = nil) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func actionButtonTapped() {
        let email = emailTextField.text
        let password = passwordTextField.text
        isLoading = true
        isLogin ? store.sendAction(.signIn(email, password))
        : store.sendAction(.createUser(email, password))
    }
    
    @objc private func googleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {[weak self] userAuth, error in
            guard let idToken = userAuth?.user.idToken,
                  let accessToken = userAuth?.user.accessToken,
                  error == nil
            else { return }
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken.tokenString,
                accessToken: accessToken.tokenString
            )
            Auth.auth().signIn(with: credential) { result, error in
                self?.callback?()
            }
        }
    }
}
// MARK: - Setup Views
private extension AuthViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Login"
        setupActionButton()
        setupRootStackView()
        setupObservers()
    }
    
    private func setupObservers() {
        store
            .events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                self.isLoading = false
                switch event {
                case .login:            self.login()
                case .notVerified:      self.notVerified()
                case .registered:       self.registered()
                case .emailSended:      self.emailSended()
                case .linkSended:       self.linkSended()
                case .error(let error): self.showError(error)
                }
            }.store(in: &bag)
    }
    
    func setupActionButton() {
        var configuration = UIButton.Configuration.filled()
        actionButton.configuration = configuration
        actionButton.configurationUpdateHandler = { [weak self] button in
            guard let self else { return }
            var config = button.configuration
            config?.showsActivityIndicator = self.isLoading
            config?.title = self.isLogin ? "Login" : "Register"
            button.configuration = config
            button.isEnabled = !self.isLoading
        }
        actionButton.addAction(UIAction {[weak self] _ in self?.actionButtonTapped() }, for: .primaryActionTriggered)
    }
    
    func setupRootStackView() {
        view.addSubview(rootStackView)
        [emailTextField, passwordTextField, repeatPasswordTextField, actionButton, UIView()].forEach { rootStackView.addArrangedSubview($0) }
        rootStackView.axis = .vertical
        rootStackView.spacing = 20
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    func updateUI() {
        actionButton.setNeedsUpdateConfiguration()
        UIView.animate(withDuration: 1.0) {
            self.repeatPasswordTextField.isHidden = self.isLogin
            self.repeatPasswordTextField.alpha = self.isLogin ? 0 : 1
//            self.buttonStackView.isHidden = !self.isLogin
//            self.buttonStackView.alpha = self.isLogin ? 1 : 0
        }
    }
    
    private func login() {
        callback?()
    }

    private func notVerified() {
        ProgressHUD.failed("Please verify email")
//        resendButton.isHidden = false
    }

    private func registered() {
        isLogin = true
        ProgressHUD.succeed("Отправлен email")
//        resendButton.isHidden = false
    }

    private func emailSended() {
//        resendButton.isHidden = true
    }

    private func linkSended() {
        ProgressHUD.succeed("Ссылка отправлена")
    }

    private func showError(_ message: String) {
        ProgressHUD.failed(message)
    }

}

#Preview {
    UINavigationController(rootViewController: AuthViewController())
}
