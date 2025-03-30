import UIKit
import ProgressHUD

class AuthViewController: UIViewController {
    private let store = AuthStore()
    private var bag = Bag()
    
    private var isLoading = false { didSet { self.actionButton.setNeedsUpdateConfiguration()}}
    private var isLogin = true {didSet { self.updateUI()}}
    
    private let emailTextField = AuthTextField(
        placeholder: "Email",
        keyboardType: .emailAddress
    )
    private let passwordTextField = AuthTextField(
        placeholder: "Password",
        isSecureTextEntry: true
    )
    private let repeatPasswordTextField = AuthTextField(
        placeholder: "Repeat Password",
        isSecureTextEntry: true
    )
    
    private let forgotButton = UIButton(type: .system)
    private let resendButton = UIButton(type: .system)
    private let actionButton = UIButton(type: .system)
    private let appleButton = UIButton(type: .system)
    private let googleButton = UIButton(type: .system)
    private let statusSwitchButton = UIButton(type: .system)
    private let buttonStackView = UIStackView()
    private let rootStackView = UIStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

private extension AuthViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Login"
        setupObservers()
        setupForgotButton()
        setupResendButton()
        setupActionButton()
        setupAppleButton()
        setupGoogleButton()
        setupStatusSwitchButton()
        setupRootStackView()
    }
    
    func setupObservers() {
        store
            .events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                self.isLoading = false
                switch event {
                case .login: self.login()
                }
            }
            .store(in: &bag)

    }
    
    func setupForgotButton() {
        buttonStackView.addArrangedSubview(forgotButton)
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Forgot Password?"
        configuration.titleAlignment = .leading
        configuration.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        forgotButton.configuration = configuration
        forgotButton.addAction(
            UIAction {[weak self] _ in self?.forgotButtonTapped()},
            for: .primaryActionTriggered
        )
    }
    
    func setupResendButton() {
        buttonStackView.addArrangedSubview(resendButton)
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Resend Email"
        configuration.titleAlignment = .trailing
        configuration.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        resendButton.configuration = configuration
        resendButton.addAction(
            UIAction { [weak self] _ in self?.resendButtonTapped()},
            for: .primaryActionTriggered
        )
        
    }
    
    func setupActionButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.imagePadding = 8
        actionButton.configuration = configuration
        actionButton.configurationUpdateHandler = { [weak self] button in
            guard let self else { return }
            var config = button.configuration
            config?.showsActivityIndicator = self.isLoading
            config?.title = self.isLogin ? "Login" : "Regiter"
            button.configuration = config
            button.isEnabled = !self.isLoading
        }
        actionButton.addAction(
            UIAction {[weak self] _ in self?.actionButtonTapped()},
            for: .primaryActionTriggered
        )
    }
    
    func setupAppleButton() {
        
    }
    
    func setupGoogleButton() {
        
    }
    
    func setupStatusSwitchButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.titleAlignment = .leading
        statusSwitchButton.configuration = configuration
        statusSwitchButton.configurationUpdateHandler = { [weak self] button in
            guard let self else { return }
            var config = button.configuration
            config?.title = self.isLogin ? "Don't have an account? Sign up" : "Already have an account? Login"
            button.configuration = config
        }
        statusSwitchButton.addAction(
            UIAction {[weak self] _ in self?.isLogin.toggle()},
            for: .primaryActionTriggered
        )
    }
    
    func setupRootStackView() {
        view.addSubview(rootStackView)
        buttonStackView.distribution = .equalSpacing
        repeatPasswordTextField.isHidden = true
        repeatPasswordTextField.alpha = 0
        [
            emailTextField,
            passwordTextField,
            repeatPasswordTextField,
            buttonStackView,
            actionButton,
            UIView(),
            statusSwitchButton
        ].forEach { rootStackView.addArrangedSubview($0)}
        rootStackView.axis = .vertical
        rootStackView.distribution = .fill
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
        navigationItem.title = isLogin ? "Login" : "Sign Up"
        UIView.animate(withDuration: 1) {
            self.repeatPasswordTextField.isHidden = self.isLogin
            self.repeatPasswordTextField.alpha = self.isLogin ? 0 : 1
            self.buttonStackView.isHidden = !self.isLogin
            self.buttonStackView.alpha = self.isLogin ? 1 : 0
        }
    }
}
// MARK: - Actions
private extension AuthViewController {
    func actionButtonTapped() {
        let email = emailTextField.text
        let password = passwordTextField.text
        isLoading = true
        isLogin ? store.sendAction(.signIn(email, password)) : store.sendAction(.createUser(email, password))
    }
    
    func forgotButtonTapped() {
        
    }
    
    func resendButtonTapped() {
        
    }
    
    func login() {
        print(#function)
    }
}

#Preview {
    UINavigationController(rootViewController: AuthViewController())
}
