import UIKit

class ViewController: UIViewController {
    private var callback: Callback
    private let store = AuthStore()
    
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
    }
    
    @objc private func signInAction() {
        store.sendAction(.signIn("motiw@icloud.com", "123456"))
    }
    
    @objc private func signUpAction() {
        
    }
}

