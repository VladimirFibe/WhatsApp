import UIKit

final class ChatTitleView: UIView {
    private let titleLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 180, height: 25))
    private let subtitleLabel = UILabel(frame: CGRect(x: 5, y: 22, width: 180, height: 20))
    
    init(name: String, frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        titleLabel.text = name
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.textAlignment = .left
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with show: Bool) {
        subtitleLabel.text = show ? "Typing..." : ""
    }
}
