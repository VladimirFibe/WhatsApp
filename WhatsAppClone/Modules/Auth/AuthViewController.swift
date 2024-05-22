import UIKit
import ProgressHUD

class AuthViewController: UIViewController {
    private let store = AuthStore()
    public var callback: Callback?
    private var bag = Bag()
    private var isLoading = false { didSet { self.actionButton.setNeedsUpdateConfiguration() }}
    private var isLogin = true { didSet { self.updateUI()}}
    private let emailTextField = AuthTextField(placeholder: "Email")
    private let passwordTextField = AuthTextField(placeholder: "Password", isSecureTextEntry: true)
    private let repeatTextField = AuthTextField(placeholder: "Repeat Password", isSecureTextEntry: true)

    private let forgotButton: UIButton = {
        $0.setTitle("Forgot Password?", for: [])
        return $0
    }(UIButton(type: .system))

    private let resendButton: UIButton = {
        $0.isHidden = true
        $0.setTitle("Resend Email", for: [])
        return $0
    }(UIButton(type: .system))

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
        }
        $0.addAction(UIAction { _ in
            self.actionButtonTapped()
        },
                     for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))

    private let statusSwitchLabel: UILabel = {
        $0.text = "Don't have an account?"
        return $0
    }(UILabel())

    private lazy var statusSwitchButton: UIButton = {
        var config = UIButton.Configuration.plain()
        $0.configuration = config
        $0.configurationUpdateHandler = { [weak self] button in
            guard let self else { return }
            var conig = button.configuration
            config.title = self.isLogin ? "Register" : "Login"
            button.configuration = config
        }
        $0.addAction(UIAction { _ in self.isLogin.toggle()},
                     for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))

    private lazy var statusSwitchStack: UIStackView = {
        return $0
    }(UIStackView(arrangedSubviews: [statusSwitchLabel, statusSwitchButton]))

    private lazy var buttonStackView: UIStackView = {
        $0.distribution = .equalCentering
        return $0
    }(UIStackView(arrangedSubviews: [forgotButton, resendButton]))

    private let rootStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 20
        return $0
    }(UIStackView())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupRootStackView()
        setupObservers()
    }

    func setupRootStackView() {
        view.addSubview(rootStackView)
        let statusSwitchView = UIView()
        statusSwitchView.addSubview(statusSwitchStack)
        [emailTextField, passwordTextField, repeatTextField, buttonStackView, actionButton, statusSwitchView].forEach{ rootStackView.addArrangedSubview($0)}
        repeatTextField.isHidden = true
        repeatTextField.alpha = 0
        rootStackView.snp.makeConstraints {
            $0.edges.equalTo(view.layoutMarginsGuide)
        }

        statusSwitchStack.snp.makeConstraints {
            $0.bottom.centerX.equalToSuperview()
        }
    }

    private func updateUI() {
        actionButton.setNeedsUpdateConfiguration()
        statusSwitchButton.setNeedsUpdateConfiguration()
        statusSwitchLabel.text = isLogin ? "Don't have an account?" : "Already have an account?"
        UIView.animate(withDuration: 1.0) {
            self.repeatTextField.isHidden = self.isLogin
            self.repeatTextField.alpha = self.isLogin ? 0 : 1
            self.buttonStackView.isHidden = !self.isLogin
            self.buttonStackView.alpha = self.isLogin ? 1 : 0
        }
    }
}

extension AuthViewController {
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

    private func actionButtonTapped() {
        let email = emailTextField.text
        let password = passwordTextField.text
        isLoading = true
        resendButton.isHidden = true
        isLogin ? store.sendAction(.signIn(email, password))
        : store.sendAction(.createUser(email, password))
    }

    private func login() {
        callback?()
    }

    private func notVerified() {
        ProgressHUD.failed("Please verify email")
        resendButton.isHidden = false
    }

    private func registered() {
        isLogin = true
        ProgressHUD.succeed("Отправлен email")
        resendButton.isHidden = false
    }

    private func emailSended() {
        resendButton.isHidden = true
    }

    private func linkSended() {
        ProgressHUD.succeed("Ссылка отправлена")
    }

    private func showError(_ message: String) {
        ProgressHUD.failed(message)
    }
}

@available (iOS 17.0, *)
#Preview {
    AuthViewController()
}
