import UIKit
import SnapKit

final class AuthTextField: UIView {
    private var placeholder = ""
    private var isSecureTextEntry = false { didSet { configure() }}
    private let showPasswordButton = UIButton(type: .system)

    private let label: UILabel = {
        $0.font = .systemFont(ofSize: 20)
        $0.textColor = .secondaryLabel
        return $0
    }(UILabel())

    private lazy var textField: UITextField = {
        $0.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        $0.borderStyle = .none
        return $0
    }(UITextField())

    private let separator: UIView = {
        $0.backgroundColor = .secondaryLabel
        return $0
    }(UIView())

    var text: String {
        textField.text ?? ""
    }

    @objc private func textChanged() {
        label.text = text.isEmpty ? "" : placeholder
    }

    @objc private func showChanged() {
        isSecureTextEntry.toggle()
    }

    init(placeholder: String, isSecureTextEntry: Bool = false) {
        super.init(frame: .zero)
        setupViews(placeholder: placeholder, isSecureTextEntry: isSecureTextEntry)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        textField.isSecureTextEntry = isSecureTextEntry
        let systemName = isSecureTextEntry ? "eye" : "eye.slash"
        let image = UIImage(systemName: systemName)
        showPasswordButton.setImage(image, for: [])
    }

    private func setupViews(placeholder: String, isSecureTextEntry: Bool = false) {
        [label, textField, separator].forEach { addSubview($0)}
        textField.placeholder = placeholder
        if isSecureTextEntry {
            self.isSecureTextEntry = true
            textField.rightView = showPasswordButton
            textField.rightViewMode = .always
            configure()
        } else {
            textField.isSecureTextEntry = false
        }
        self.placeholder = placeholder
        configure()
        showPasswordButton.addTarget(self, action: #selector(showChanged), for: .primaryActionTriggered)
    }

    private func setupConstraints() {
        label.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }

        textField.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(9)
            $0.leading.trailing.equalTo(label)
            $0.height.equalTo(label.snp.height)
        }

        separator.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(9)
            $0.leading.trailing.equalTo(label)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
