import UIKit

class AuthViewController: UIViewController {
    private var isLogin = true { didSet { self.updateUI()}}
    private let emailTextField = AuthTextField(placeholder: "Email")
    private let passwordTextField = AuthTextField(placeholder: "Password", isSecureTextEntry: true)
    private let repeatTextField = AuthTextField(placeholder: "Repeat Password", isSecureTextEntry: true)

    private let forgotButton: UIButton = {
        $0.setTitle("Forgot Password?", for: [])
        return $0
    }(UIButton(type: .system))

    private let resendButton: UIButton = {
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
            config.title = self.isLogin ? "Login" : "Sign In"
            button.configuration = config
        }
        $0.addAction(UIAction { _ in
            self.isLogin.toggle()
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
        $0.addAction(UIAction { _ in
            self.isLogin.toggle()
        },
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
//        statusSwitchLabel.text = isLogin ? "Don't have an account?" : "Already have an account?"
        UIView.animate(withDuration: 1.0) {
            self.repeatTextField.isHidden = self.isLogin
            self.repeatTextField.alpha = self.isLogin ? 0 : 1
            self.buttonStackView.isHidden = !self.isLogin
            self.buttonStackView.alpha = self.isLogin ? 1 : 0
            self.statusSwitchLabel.text = self.isLogin ? "Don't have an account?" : "Already have an account?"
        }
    }
}

@available (iOS 17.0, *)
#Preview {
    AuthViewController()
}
