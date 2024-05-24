import UIKit
import SnapKit

final class AuthTextField: UIView {
    private var placeholder: String

    private let label: UILabel = {
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 20)
        return $0
    }(UILabel())

    private lazy var textField: UITextField = {
        $0.borderStyle = .none
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.addAction(UIAction { _ in self.configureLabel()}, for: .editingChanged)
        return $0
    }(UITextField())

    private let separatorView: UIView = {
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

    var text: String {
        textField.text ?? ""
    }

    init(placeholder: String, 
         isSecureTextEntry: Bool = false,
         keyboardType: UIKeyboardType = .default) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        setupLabel()
        setupTextField(isSecureTextEntry, keyboardType: keyboardType)
        setupSeparatorView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
    }

    private func setupTextField(_ isSecureTextEntry: Bool, keyboardType: UIKeyboardType) {
        addSubview(textField)
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        if isSecureTextEntry {
            textField.isSecureTextEntry = true
            textField.rightView = showPasswordButton
            textField.rightViewMode = .always
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
    }

    private func setupSeparatorView() {
        addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    private func configureLabel() {
        label.text = text.isEmpty ? "" : placeholder
    }

    private func toggleSecure() {
        textField.isSecureTextEntry.toggle()
        showPasswordButton.setNeedsUpdateConfiguration()
    }
}

@available (iOS 17.0, *)
#Preview {
    AuthTextField(placeholder: "Email", isSecureTextEntry: true)
}
