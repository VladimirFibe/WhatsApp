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
    private let forgotButton = UIButton(type: .system)
    private let resendButton = UIButton(type: .system)
    private let actionButton = UIButton(type: .system)
    private let appleButton = UIButton(type: .system)
    private let googleButton = UIButton(type: .system)
    private let statusSwitchButton = UIButton(type: .system)
    private let buttonStackView = UIStackView()
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
}
// MARK: - Setup Views
private extension AuthViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Login"
        setupForgotButton()
        setupResendButton()
        setupActionButton()
        setupAppleButton()
        setupGoogleButton()
        setupStatusSwitchButton()
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
    
    func setupForgotButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Forgot Password?"
        configuration.titleAlignment = .leading
        configuration.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        forgotButton.configuration = configuration
        forgotButton.addAction(UIAction {[weak self] _ in
            let email = self?.emailTextField.text ?? ""
            self?.store.sendAction(.sendPasswordReset(email))
        },
        for: .touchUpInside)
    }
    
    func setupResendButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.titleAlignment = .trailing
        configuration.title = "Resend Email"
        configuration.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        resendButton.configuration = configuration
        resendButton.addAction(UIAction {[weak self] _ in
            let email = self?.emailTextField.text ?? ""
            self?.store.sendAction(.sendEmail(email))
        },
        for: .touchUpInside)
    }
    
    func setupActionButton() {
        let configuration = UIButton.Configuration.filled()
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
    
    func setupAppleButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Login with Apple"
        appleButton.configuration = configuration
    }
    
    func setupGoogleButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Login with Google"
        googleButton.configuration = configuration
        googleButton.addAction(UIAction {[weak self] _ in self?.googleButtonTapped() }, for: .primaryActionTriggered)
    }
    
    private func setupStatusSwitchButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.titleAlignment = .leading
        statusSwitchButton.configuration = configuration
        statusSwitchButton.configurationUpdateHandler = { [weak self] button in
            guard let self else { return }
            var config = button.configuration
            config?.title = self.isLogin ? "Don't have an account? Sign Up" : "Already have an account? Login"
            button.configuration = config
        }
        statusSwitchButton.addAction(UIAction { [weak self] _ in self?.isLogin.toggle() }, for: .primaryActionTriggered)
    }
    
    func setupRootStackView() {
        view.addSubview(rootStackView)
        [
            emailTextField,
            passwordTextField,
            repeatPasswordTextField,
            buttonStackView,
            actionButton,
            appleButton,
            googleButton,
            UIView(),
            statusSwitchButton
        ].forEach { rootStackView.addArrangedSubview($0) }
        rootStackView.axis = .vertical
        rootStackView.spacing = 20
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        repeatPasswordTextField.isHidden = true
        repeatPasswordTextField.alpha = 0
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    func updateUI() {
        actionButton.setNeedsUpdateConfiguration()
        UIView.animate(withDuration: 1.0) {
            self.repeatPasswordTextField.isHidden = self.isLogin
            self.repeatPasswordTextField.alpha = self.isLogin ? 0 : 1
            self.buttonStackView.isHidden = !self.isLogin
            self.buttonStackView.alpha = self.isLogin ? 1 : 0
        }
    }
}
// MARK: - Actions
private extension AuthViewController {
    func login() {
        callback?()
    }

    func notVerified() {
        ProgressHUD.failed("Please verify email")
//        resendButton.isHidden = false
    }

    func registered() {
        isLogin = true
        ProgressHUD.succeed("Отправлен email")
//        resendButton.isHidden = false
    }

    func emailSended() {
//        resendButton.isHidden = true
    }

    func linkSended() {
        ProgressHUD.succeed("Ссылка отправлена")
    }

    func showError(_ message: String) {
        ProgressHUD.failed(message)
    }
    
    func actionButtonTapped() {
        let email = emailTextField.text
        let password = passwordTextField.text
        isLoading = true
        isLogin ? store.sendAction(.signIn(email, password))
        : store.sendAction(.createUser(email, password))
    }
    
    func appleButtonTapped() {
        
    }
    
    func googleButtonTapped() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {
            [weak self] userAuth,
            error in
            guard let idToken = userAuth?.user.idToken,
                  let accessToken = userAuth?.user.accessToken,
                  error == nil
            else { return }
            self?.store.sendAction(
                .googleSignIn(
                    idToken.tokenString,
                    accessToken.tokenString
                )
            )
        }
    }
}

#Preview {
    UINavigationController(rootViewController: AuthViewController())
}
