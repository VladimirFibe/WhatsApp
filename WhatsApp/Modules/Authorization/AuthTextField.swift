import UIKit

final class AuthTextField: BaseView {
    private let label = {
        return $0
    }(UILabel())

    private let textField = {
        return $0
    }(UITextField())

    private let separator = {
        return $0
    }(UIView())

    var text: String {
        textField.text ?? ""
    }

    func configure(placeholder: String) {
        label.text = placeholder
        textField.placeholder = placeholder
    }
}
// MARK: - Setup
extension AuthTextField {
    override func setupViews() {
        [label, textField, separator].forEach { addSubview($0)}
    }

    override func setupConstraints() {
        label.snp.makeConstraints { $0.top.leading.trailing.equalToSuperview()}
        textField.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom)
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
