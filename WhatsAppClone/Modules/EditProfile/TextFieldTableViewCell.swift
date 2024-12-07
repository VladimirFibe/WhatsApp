import UIKit

final class TextFieldTableViewCell: UITableViewCell {
    private let textField = UITextField()
    
    var text: String { textField.text ?? "" }
    
    public func configure(delegate: UITextFieldDelegate) {
        textField.delegate = delegate
    }
    
    public func configure(with text: String) {
        textField.text = text
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.readableContentGuide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.readableContentGuide.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
