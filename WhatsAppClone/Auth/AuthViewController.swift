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
    
    private let emailTextField = AuthTextField(placeholder: "Email", keyboardType: .emailAddress)
    private let passwordTextField = AuthTextField(placeholder: "Password", isSecureTextEntry: true)
    private let repeatPasswordTextField = AuthTextField(placeholder: "Repeat Password", isSecureTextEntry: true)
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
    
    @objc private func login() {
        print("login", emailTextField.text, passwordTextField.text, repeatPasswordTextField.text)
//        Auth.auth().signIn(withEmail: "motiw@icloud.com", password: "123456") {[weak self] _, _ in
//            print("login complete", self?.callback == nil, self == nil)
//            self?.callback?()
//        }
    }
    
    @objc private func googleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {[weak self] userAuth, error in
            guard let idToken = userAuth?.user.idToken,
                  let accessToken = userAuth?.user.accessToken,
                  error == nil
            else { return }
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken.tokenString,
                accessToken: accessToken.tokenString
            )
            Auth.auth().signIn(with: credential) { result, error in
                self?.callback?()
            }
        }
    }
}
// MARK: - Setup Views
private extension AuthViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Auth"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Login",
            style: .done,
            target: self,
            action: #selector (login)
        )
        setupRootStackView()
    }
    
    func setupRootStackView() {
        view.addSubview(rootStackView)
        [emailTextField, passwordTextField, repeatPasswordTextField, UIView()].forEach { rootStackView.addArrangedSubview($0) }
        rootStackView.axis = .vertical
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

#Preview {
    UINavigationController(rootViewController: AuthViewController())
}
