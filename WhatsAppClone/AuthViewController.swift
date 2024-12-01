import UIKit
import FirebaseAuth

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
            action: #selector(login)
        )
    }
    
    @objc private func login() {
        print("login")
        Auth.auth().signIn(withEmail: "motiw@icloud.com", password: "123456") {[weak self] _, _ in
            print("login complete", self?.callback == nil, self == nil)
            self?.callback?()
        }
    }
}
