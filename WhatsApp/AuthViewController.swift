import UIKit

class AuthViewController: UIViewController {
    private let emailTextField = AuthTextField(
        placeholder: "Email",
        keyboardType: .emailAddress
    )
    private let passwordTextField = AuthTextField(
        placeholder: "Password",
        isSecureTextEntry: true
    )
    private let repeatPasswordTextField = AuthTextField(
        placeholder: "Repeat Password",
        isSecureTextEntry: true
    )
    private let rootStackView = UIStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

private extension AuthViewController {
    func setupViews() {
        setupRootStackView()
    }
    
    func setupRootStackView() {
        view.addSubview(rootStackView)
        [
            emailTextField,
            passwordTextField,
            repeatPasswordTextField,
            UIView()
        ].forEach { rootStackView.addArrangedSubview($0)}
        rootStackView.axis = .vertical
        rootStackView.distribution = .fill
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
