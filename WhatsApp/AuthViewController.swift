import UIKit
import ProgressHUD

class AuthViewController: UIViewController {
    
    private var isLoading = false
    private var isLogin = true
    
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
        
    }
    
    func setupForgotButton() {
        
    }
    
    func setupResendButton() {
        
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
        
    }
    
    func setupRootStackView() {
        view.addSubview(rootStackView)
        buttonStackView.distribution = .equalSpacing
        [
            emailTextField,
            passwordTextField,
            repeatPasswordTextField,
            buttonStackView,
            actionButton,
            UIView()
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
}
// MARK: - Actions
private extension AuthViewController {
    func actionButtonTapped() {
        let email = emailTextField.text
        let password = passwordTextField.text
        isLoading = true
        print("login")
    }
}

#Preview {
    UINavigationController(rootViewController: AuthViewController())
}
