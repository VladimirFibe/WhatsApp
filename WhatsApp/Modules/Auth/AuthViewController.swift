import UIKit

class AuthViewController: BaseViewController {
    private var isLogin = false { didSet { updateUI() }}
    private lazy var titleLabel: UILabel = {
        $0.text = isLogin ? "Login" : "Register"
        $0.font = AppFont.book.s35()
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private let emailTextField = AuthTextField(
        placeholder: "Email",
        isSecureTextEntry: false
    )

    private let passwordTextField = AuthTextField(placeholder: "Password")
    private let repeatTextField = AuthTextField(placeholder: "Repeat Password")
    private let middleView = UIView()

    private lazy var forgotButton: UIButton = {
        $0.contentHorizontalAlignment = .leading
        $0.setTitle("Forgot Password?", for: [])
        $0.addTarget(self, action: #selector(forgotButtonTapped), for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))

    private lazy var resendButton: UIButton = {
        $0.contentHorizontalAlignment = .trailing
        $0.isHidden = true
        $0.setTitle("Resend Email", for: [])
        $0.addTarget(self, action: #selector(resendButtonTapped), for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))

    private lazy var loginButton: UIButton = {
        $0.setTitle("Login", for: [])
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))

    private let bottomLabel: UILabel = {
        $0.text = "Don't have an account?"
        $0.font = AppFont.book.s16()
        return $0
    }(UILabel())

    private lazy var bottomButton: UIButton = {
        $0.contentHorizontalAlignment = .trailing
        $0.setTitle("Register", for: [])
        $0.addTarget(
            self,
            action: #selector(bottomButtonTapped),
            for: .primaryActionTriggered
        )
        return $0
    }(UIButton(type: .system))

    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [
        emailTextField, passwordTextField, repeatTextField, middleView, loginButton
    ]))

    private lazy var bottomStackView: UIStackView = {
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [bottomLabel, bottomButton]))
}

extension AuthViewController {
    private func updateUI() {
        titleLabel.text = isLogin ? "Login" : "Register"
        bottomButton.setTitle(isLogin ? "Register" : "Login", for: [])
        loginButton.setTitle(isLogin ? "Login" : "Register", for: [])
        bottomLabel.text = isLogin ? "Don't have an account?" : "Already have an account?"

        UIView.animate(withDuration: 0.5) {
            self.repeatTextField.isHidden = self.isLogin
            self.repeatTextField.alpha = self.isLogin ? 0 : 1
        }
    }

    @objc private func forgotButtonTapped() {
//        let email = emailTextField.text
//        store.sendAction(.resetPassword(email))
    }

    @objc private func resendButtonTapped() {
//        store.sendAction(.sendEmailVerification)
    }

    @objc private func loginButtonTapped() {
        isLogin.toggle()
//        if isDataInputedFor(isLogin ? .login : .register) {
//            let email = emailTextField.text
//            let password = passwordTextField.text
//            isLogin ? store.sendAction(.login(email, password))
//            : store.sendAction(.register(email, password))
//        } else {
//            ProgressHUD.failed()
//        }
    }

    @objc private func bottomButtonTapped() {
        isLogin.toggle()
    }

    @objc private func backgroundTapped() {
        view.endEditing(false)
    }
}

extension AuthViewController {
    override func setupViews() {
        super.setupViews()
        [
            titleLabel, stackView, bottomStackView
        ].forEach { view.addSubview($0)}
        middleView.addSubview(forgotButton)
        middleView.addSubview(resendButton)
        repeatTextField.isHidden = isLogin
        setupBackgroundTap()
        repeatTextField.alpha = isLogin ? 0 : 1
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.isLogin.toggle() }
    }

    func setupBackgroundTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
    }

    override func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(100)
            $0.leading.trailing.equalTo(titleLabel)
        }

        forgotButton.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }

        resendButton.snp.makeConstraints {
            $0.top.bottom.equalTo(forgotButton)
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(forgotButton.snp.trailing)
        }

        bottomStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

#Preview {
    AuthViewController()
}
