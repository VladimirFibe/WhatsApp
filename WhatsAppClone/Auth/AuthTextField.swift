import UIKit

final class AuthTextField: UIView {
    private var placeholder: String
    
    private let label: UILabel = {
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 20)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var textField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.borderStyle = .none
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.addAction(UIAction { _ in self.configureLabel()}, for: .editingChanged)
        return $0
    }(UITextField())
    
    private let separatorView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .secondaryLabel
        return $0
    }(UIView())
    
    private lazy var showPasswordButton: UIButton = {
        var config = UIButton.Configuration.plain()
        $0.configuration = config
        $0.configurationUpdateHandler = { [weak self] button in
            var config = button.configuration
            let isSecure = self?.textField.isSecureTextEntry ?? false
            config?.image = isSecure ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
            button.configuration = config
        }
        $0.addAction(UIAction { _ in self.toggleSecure()},
                     for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))
    
    public var text: String {
        textField.text ?? ""
    }
    
    init(placeholder: String,
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
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        label.text = text.isEmpty ? "" : placeholder
    }
    
    private func toggleSecure() {
        textField.isSecureTextEntry.toggle()
        showPasswordButton.setNeedsUpdateConfiguration()
    }
    
    private func setupViews() {
        [label, textField, separatorView].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.heightAnchor.constraint(equalToConstant: 24),
            
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            separatorView.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

#Preview {
    UINavigationController(rootViewController: AuthViewController(callback: {}))
}
