import UIKit
import SnapKit

final class AuthTextField: UIView {
    private var placeholder = ""

    init(
        placeholder: String,
        isSecureTextEntry: Bool = true,
        rightButton: UIButton = UIButton()
    ) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecureTextEntry
        if isSecureTextEntry {
            textField.rightView = rightButton
            textField.rightViewMode = .always
        }
        self.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let label: UILabel = {
        $0.font = AppFont.book.s20()
        $0.textColor = .secondaryLabel
        return $0
    }(UILabel())

    private lazy var textField: UITextField = {
        $0.addTarget(
            self,
            action: #selector(textChanged),
            for: .editingChanged
        )
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

    @objc func textChanged() {
        label.text = text.isEmpty ? "" : placeholder
    }

    func updateSecure(_ isSecureTextEntry: Bool) {
        textField.isSecureTextEntry = isSecureTextEntry
    }
}

extension AuthTextField {
    func setupViews() {
        [label, textField, separator].forEach { addSubview($0)}
    }

    func setupConstraints() {
        label.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }

        textField.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(9)
            $0.leading.trailing.equalTo(label)
            $0.height.equalTo(24)
        }

        separator.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(9)
            $0.leading.trailing.equalTo(label)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
}

#Preview {
    AuthTextField(placeholder: "Email")
}
