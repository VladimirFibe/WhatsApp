import UIKit

final class AuthTextField: UIView {
    private var placeholder: String
    
    private let label = UILabel()
    private let textField = UITextField()
    private let separatorView = UIView()
    public var text: String { textField.text ?? "" }
    private let showPasswordButton = UIButton(type: .system)
    
    init(placeholder: String = "Email",
         isSecureTextEntry: Bool = false,
         keyboardType: UIKeyboardType = .default) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        if isSecureTextEntry {
            textField.isSecureTextEntry = true
            textField.rightView = showPasswordButton
            textField.rightViewMode = .always
        }
        setupLabel()
        setupTextField(isSecureTextEntry, keyboardType: keyboardType)
        setupShowPasswordButton()
        setupSeparatorView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AuthTextField {
    func setupLabel() {
        addSubview(label)
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func setupTextField(
        _ isSecureTextEntry: Bool,
        keyboardType: UIKeyboardType
    ) {
        addSubview(textField)
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addAction(
            UIAction {[weak self] _ in self?.configureLabel()},
            for: .editingChanged)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setupShowPasswordButton() {
        let configuration = UIButton.Configuration.plain()
        showPasswordButton.configuration = configuration
        showPasswordButton.configurationUpdateHandler = { [weak self] button in
            var config = button.configuration
            let isSecure = self?.textField.isSecureTextEntry ?? false
            config?.image = isSecure ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
            button.configuration = config
        }
        showPasswordButton.addAction(
            UIAction {[weak self] _ in self?.toggleSecure()},
            for: .primaryActionTriggered)
    }
    
    func setupSeparatorView() {
        addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .secondaryLabel
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureLabel() {
        label.text = text.isEmpty ? "" : placeholder
        print(label.text ?? "label.text is nil")
    }
    
    func toggleSecure() {
        textField.isSecureTextEntry.toggle()
        showPasswordButton.setNeedsUpdateConfiguration()
    }
}

#Preview {
    UINavigationController(rootViewController: AuthViewController())
}
