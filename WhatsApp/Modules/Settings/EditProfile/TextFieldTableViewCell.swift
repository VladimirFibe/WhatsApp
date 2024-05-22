import UIKit

class TextFieldTableViewCell: BaseTableViewCell {
    private let textField: UITextField = {
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .done
        $0.placeholder = "Enter name"
        return $0
    }(UITextField())

    var text: String {
        textField.text ?? ""
    }

    public func configure(delegate: UITextFieldDelegate) {
        textField.delegate = delegate
    }

    public func configure(_ text: String) {
        textField.text = text
    }
}
// MARK: - Setup
extension TextFieldTableViewCell {
    override func setupViews() {
        contentView.addSubview(textField)
    }

    override func setupConstraints() {
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
