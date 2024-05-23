import UIKit

final class ChatTitleView: UIView {
    let titleLabel: UILabel = {
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.adjustsFontSizeToFitWidth = true
        return $0
    }(UILabel(frame: CGRect(x: 5, y: 0, width: 180, height: 25)))

    let subTitleLabel: UILabel = {
        $0.text = "typing ..."
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        $0.adjustsFontSizeToFitWidth = true
        return $0
    }(UILabel(frame: CGRect(x: 5, y: 22, width: 180, height: 20)))

    init(name: String, frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        titleLabel.text = name
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String) {
        subTitleLabel.text = text
    }
}
