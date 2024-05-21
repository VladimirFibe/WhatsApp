import UIKit
import ProgressHUD

class AuthViewController: BaseViewController {
    private var store: AuthStore
    private var isLogin = true { didSet { updateUI() }}

    enum Flow {
        case login
        case register
        case forgot
    }

    private var callback: Callback?
    private let emailTextField = AuthTextField(placeholder: "Email")
    private let passwordTextField = AuthTextField(placeholder: "Password", isSecureTextEntry: true)
    private let repeatTextField = AuthTextField(placeholder: "Repeat Password", isSecureTextEntry: true)
    
    private let forgotButton: UIButton = {
        $0.contentHorizontalAlignment = .leading
        $0.setTitle("Forgot Password?", for: [])
        return $0
    }(UIButton(type: .system))

    private let resendButton: UIButton = {
        $0.contentHorizontalAlignment = .trailing
        $0.isHidden = true
        $0.setTitle("Resend Email", for: [])
        return $0
    }(UIButton(type: .system))

    private let middleView = UIView()

    private let actionButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Login"
        config.cornerStyle = .medium
        config.imagePadding = 8
        $0.configuration = config
        return $0
    }(UIButton(type: .system))

    private let rootStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView())

    private let authStatusSwitch = AuthStatusSwitch()

    init(store: AuthStore, callback: Callback? = nil) {
        self.store = store
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Actions
extension AuthViewController {
    @objc private func authSwitchTapped() {
        isLogin.toggle()
    }

    @objc private func actionButtonTapped() {
        if let error = errorMessage(isLogin ? .login : .register) {
            ProgressHUD.failed(error)
        } else {
            let email = emailTextField.text
            let password = passwordTextField.text
            actionButton.configuration?.showsActivityIndicator = true
            resendButton.isHidden = true
            isLogin ? store.sendAction(.signIn(email, password))
            : store.sendAction(.createUser(email, password))
        }
    }

    @objc private func forgotButtonTapped() {
        if let error = errorMessage(.forgot) {
            ProgressHUD.failed(error)
        } else {
            let email = emailTextField.text
            store.sendAction(.sendPasswordReset(email))
        }
    }

    @objc private func resendButtonTapped() {
        if let error = errorMessage(.forgot) {
            ProgressHUD.failed(error)
        } else {
            let email = emailTextField.text
            store.sendAction(.sendEmail(email))
        }
    }

    @objc private func backgroundTapped() {
        view.endEditing(false)
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

    private func errorMessage(_ flow: Flow) -> String? {
        if emailTextField.text.isEmpty {
            return "Email is empty"
        } else if flow == .forgot {
            return nil
        } else if passwordTextField.text.isEmpty {
            return "Password is empty"
        } else if flow == .login {
            return nil
        } else if passwordTextField.text == repeatTextField.text {
            return nil
        } else {
            return "Password not equal"
        }
    }
}
// MARK: - Setup Views
extension AuthViewController {
    override func setupViews() {
        super.setupViews()
        [rootStackView, actionButton, authStatusSwitch].forEach {
            view.addSubview($0)
        }
        authStatusSwitch.configure(self, action: #selector(authSwitchTapped))
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .primaryActionTriggered)
        forgotButton.addTarget(self, action: #selector(forgotButtonTapped), for: .primaryActionTriggered)
        resendButton.addTarget(self, action: #selector(resendButtonTapped), for: .primaryActionTriggered)
        setupRootStackView()
        setupBackgroundTap()
        updateUI()
        setupObservers()
    }

    private func setupRootStackView() {
        [emailTextField, passwordTextField, repeatTextField, middleView].forEach {
            rootStackView.addArrangedSubview($0)
        }
        middleView.addSubview(forgotButton)
        middleView.addSubview(resendButton)
    }

    private func updateUI() {
        authStatusSwitch.configure(with: isLogin)
        actionButton.configuration?.title = isLogin ? "Login" : "Register"
        navigationItem.title = isLogin ? "Login" : "Register"
        UIView.animate(withDuration: 0.5) {
            self.repeatTextField.isHidden = self.isLogin
            self.repeatTextField.alpha = self.isLogin ? 0 : 1
            self.middleView.isHidden = !self.isLogin
            self.middleView.alpha = self.isLogin ? 1 : 0
        }
    }

    private func setupObservers() {
        store
            .events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                self.actionButton.configuration?.showsActivityIndicator = false
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

    func setupBackgroundTap() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(backgroundTapped)
        )
        view.addGestureRecognizer(tapGesture)
    }

    override func setupConstraints() {
        let padding = 20.0

        rootStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.trailing.equalToSuperview().inset(padding)
        }

        actionButton.snp.makeConstraints {
            $0.top.equalTo(rootStackView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(padding)
            $0.height.equalTo(50)
        }

        authStatusSwitch.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
        }

        forgotButton.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }

        resendButton.snp.makeConstraints {
            $0.top.bottom.equalTo(forgotButton)
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(forgotButton.snp.trailing)
            $0.width.equalTo(forgotButton.snp.width)
        }
    }
}
