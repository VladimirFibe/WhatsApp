import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

final class AuthViewController: UIViewController {
    var callback: Callback?
    init(callback: Callback? = nil) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Auth"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "bell"),
            style: .done,
            target: self,
            action: #selector(googleLogin)
        )
    }
    
    @objc private func login() {
        print("login")
        Auth.auth().signIn(withEmail: "motiw@icloud.com", password: "123456") {[weak self] _, _ in
            print("login complete", self?.callback == nil, self == nil)
            self?.callback?()
        }
    }
    
    @objc private func googleLogin() {
        print("google login")
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        print(clientID)
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController
        else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) {[weak self] userAuth, error in
            guard let idToken = userAuth?.user.idToken,
                  let accessToken = userAuth?.user.accessToken  else { return }
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
