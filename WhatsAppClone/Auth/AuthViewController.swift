import UIKit
import ProgressHUD

class AuthViewController: UIViewController {
    private var callback: Callback
    private let store = AuthStore()
    private var bag = Bag()

    private let emailTextField = AuthTextField(placeholder: "Email")
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "SignUp", style: .plain, target: self, action: #selector(signUpAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SignIn", style: .plain, target: self, action: #selector(signInAction))
        setupObservers()
        setupRootStackView()
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
//                self.isLoading = false
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
//        resendButton.isHidden = false
    }

    private func registered() {
//        isLogin = true
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
// MARK: - Setup Views
private extension AuthViewController {
    func setupRootStackView() {
        view.addSubview(rootStackView)
        rootStackView.addArrangedSubview(emailTextField)
        rootStackView.addArrangedSubview(UIView())
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
}

#Preview {
    UINavigationController(rootViewController: AuthViewController(callback: {}))
}
