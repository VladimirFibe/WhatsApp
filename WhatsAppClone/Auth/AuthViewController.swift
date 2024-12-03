import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

final class AuthViewController: UIViewController {
    var callback: Callback?
    
    private let emailTextField = AuthTextField(placeholder: "Password", isSecureTextEntry: true)
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
        print("login")
        Auth.auth().signIn(withEmail: "motiw@icloud.com", password: "123456") {[weak self] _, _ in
            print("login complete", self?.callback == nil, self == nil)
            self?.callback?()
        }
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
            image: UIImage(systemName: "bell"),
            style: .done,
            target: self,
            action: #selector(googleLogin)
        )
        setupEmailTextField()
    }
    
    func setupEmailTextField() {
        view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
}

#Preview {
    UINavigationController(rootViewController: AuthViewController())
}
