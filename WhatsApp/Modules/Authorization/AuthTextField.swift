import UIKit

final class AuthTextField: BaseView {
    private var placeholder = ""

    private let label = {
        $0.textColor = .secondaryLabel
        return $0
    }(UILabel())

    private lazy var textField = {
        $0.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        return $0
    }(UITextField())

    private let separator = {
        $0.backgroundColor = .label
        return $0
    }(UIView())

    var text: String {
        textField.text ?? ""
    }

    func configure(placeholder: String, isSecureTextEntry: Bool = true) {
        textField.placeholder = placeholder
        self.placeholder = placeholder
        textField.isSecureTextEntry = isSecureTextEntry
    }

    @objc func textChanged() {
        label.text = text.isEmpty ? "" : placeholder
    }

    func updateUI(with show: Bool) {
        label.alpha = show ? 1 : 0
        textField.alpha = show ? 1 : 0
        separator.alpha = show ? 1 : 0
    }
}
// MARK: - Setup
extension AuthTextField {
    override func setupViews() {
        [label, textField, separator].forEach { addSubview($0)}
    }

    override func setupConstraints() {
        label.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom)
            $0.height.equalTo(24)
            $0.leading.trailing.equalTo(label)
        }
        separator.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom)
            $0.leading.trailing.equalTo(label)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
}
