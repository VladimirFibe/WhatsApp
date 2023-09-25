import UIKit
import SnapKit
import ProgressHUD

class AuthorizationViewController: BaseViewController {
    let store: AuthStore
    enum Flow {
        case login
        case register
        case forgot
    }
    private var isLogin = false {
        didSet { updateUI() }
    }
    private let titleLabel = {
        $0.text = "Register"
        $0.font = .systemFont(ofSize: 35)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    private let emailTextField = {
        $0.configure(placeholder: "Email", isSecureTextEntry: false)
        return $0
    }(AuthTextField())

    private let passwordTextField = {
        $0.configure(placeholder: "Password")
        return $0
    }(AuthTextField())

    private let repeatPasswordTextField = {
        $0.configure(placeholder: "Repeat Password")
        return $0
    }(AuthTextField())

    private lazy var stackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [
        emailTextField,
        passwordTextField,
        repeatPasswordTextField,
        middleView,
        loginButton
    ]))

    private lazy var forgotButton: UIButton = {
        $0.contentHorizontalAlignment = .leading
        $0.setTitle("Forgot Password?", for: [])
        $0.addTarget(self, action: #selector(forgotButtonTapped), for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))

    private lazy var resendButton: UIButton = {
        $0.contentHorizontalAlignment = .trailing
        $0.isHidden = false
        $0.setTitle("Resend Email", for: [])
        $0.addTarget(self, action: #selector(resendButtonTapped), for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))

    private lazy var loginButton: UIButton = {
        $0.setTitle("Regiter", for: [])
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))

    private let bottomLabel = {
        $0.text = "Already have an account?"
        return $0
    }(UILabel())

    private lazy var bottomButton: UIButton = {
        $0.contentHorizontalAlignment = .trailing
        $0.setTitle("Login", for: [])
        $0.addTarget(
            self,
            action: #selector(bottomButtonTapped),
            for: .primaryActionTriggered
        )
        return $0
    }(UIButton(type: .system))

    private lazy var middleView = {
        return $0
    }(UIView())

    private lazy var bottomStackView = {
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [bottomLabel, bottomButton]))
    
    @objc private func forgotButtonTapped() {
        if isDataInputedFor(isLogin ? .login : .register) {
            print(#function)
        } else {
            ProgressHUD.showFailed("Email is required")
        }
    }

    @objc private func resendButtonTapped() {
        if isDataInputedFor(isLogin ? .login : .register) {
            print(#function)
        } else {
            ProgressHUD.showFailed("Email is required")
        }
    }

    @objc private func loginButtonTapped() {
        if isDataInputedFor(isLogin ? .login : .register) {
            let email = emailTextField.text
            let password = passwordTextField.text
            store.sendAction(.register(email, password))
        } else {
            ProgressHUD.showFailed("All fields are required")
        }
    }

    @objc private func bottomButtonTapped() {
        isLogin.toggle()
    }

    @objc private func backgroundTapped() {
        view.endEditing(false)
    }

    private func updateUI() {
        titleLabel.text = isLogin ? "Login" : "Register"
        bottomButton.setTitle(isLogin ? "Register" : "Login", for: [])
        loginButton.setTitle(isLogin ? "Login" : "Register", for: [])
        bottomLabel.text = isLogin ? "Don't have an account?" : "Already have an account?"
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordTextField.isHidden = self.isLogin
            self.repeatPasswordTextField.alpha = self.isLogin ? 0 : 1
        }
    }

    private func isDataInputedFor(_ flow: Flow) -> Bool {
        switch flow {

        case .login: return !emailTextField.text.isEmpty && !passwordTextField.text.isEmpty
        case .register: return !emailTextField.text.isEmpty && !passwordTextField.text.isEmpty && passwordTextField.text == repeatPasswordTextField.text
        case .forgot: return !emailTextField.text.isEmpty
        }
    }

    init(store: AuthStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AuthorizationViewController {
    override func setupViews() {
        super.setupViews()
        [titleLabel, 
         stackView,
         bottomStackView
        ].forEach { view.addSubview($0)}

        middleView.addSubview(forgotButton)
        middleView.addSubview(resendButton)
        setupBackgroundTap()
    }

    func setupBackgroundTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
    }

    override func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(100)
            $0.leading.trailing.equalTo(titleLabel)
        }

        bottomStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        forgotButton.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }

        resendButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(forgotButton.snp.trailing)
        }
    }
}
