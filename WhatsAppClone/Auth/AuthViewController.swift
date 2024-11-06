import UIKit
import ProgressHUD

class AuthViewController: UIViewController {
    private var callback: Callback
    private let store = AuthStore()
    private var bag = Bag()
    private var isLoading = false { didSet { self.actionButton.setNeedsUpdateConfiguration() }}
    private var isLogin = true { didSet { self.updateUI()}}

    private let emailTextField = AuthTextField(placeholder: "Email", keyboardType: .emailAddress)
    private let passwordTextField = AuthTextField(placeholder: "Password", isSecureTextEntry: true)
    private let repeatTextField = AuthTextField(placeholder: "Repeat Password", isSecureTextEntry: true)
    private lazy var actionButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.imagePadding = 8
        $0.configuration = config
        $0.configurationUpdateHandler = { [weak self] button in
            guard let self else { return }
            var conig = button.configuration
            config.showsActivityIndicator = self.isLoading
            config.title = self.isLogin ? "Login" : "Sign In"
            button.configuration = config
            button.isEnabled = !self.isLoading
        }
        $0.addAction(UIAction { _ in
            self.actionButtonTapped()
        },
                     for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))

    private let rootStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 20
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    init(callback: @escaping Callback) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupObservers()
        setupRootStackView()
    }
    
    private func actionButtonTapped() {
        let email = emailTextField.text
        let password = passwordTextField.text
        isLoading = true
        isLogin ? store.sendAction(.signIn(email, password))
        : store.sendAction(.createUser(email, password))
    }
    
    @objc private func signInAction() {
        store.sendAction(.signIn("motiw@icloud.com", "123456"))
    }
    
    @objc private func signUpAction() {
        
    }
    
    private func setupObservers() {
        store
            .events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
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
    
    private func login() {
        callback()
    }

    private func notVerified() {
        ProgressHUD.failed("Please verify email")
    }

    private func registered() {
        ProgressHUD.succeed("Отправлен email")
    }

    private func emailSended() {
    }

    private func linkSended() {
        ProgressHUD.succeed("Ссылка отправлена")
    }

    private func showError(_ message: String) {
        ProgressHUD.failed(message)
    }
    
    private func updateUI() {
        actionButton.setNeedsUpdateConfiguration()
        UIView.animate(withDuration: 1.0) {
            self.repeatTextField.isHidden = self.isLogin
            self.repeatTextField.alpha = self.isLogin ? 0 : 1
        }
    }

}
// MARK: - Setup Views
private extension AuthViewController {
    func setupRootStackView() {
        view.addSubview(rootStackView)
        [emailTextField, passwordTextField, repeatTextField, actionButton, UIView()].forEach { rootStackView.addArrangedSubview($0)}
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
