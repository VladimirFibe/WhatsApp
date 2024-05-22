import UIKit

class PhotoTableViewCell: UITableViewCell {
    static let identifier = "PhotoTableViewCell"
    public var callback: Callback?

    private let photoImageView: UIImageView = {
        $0.image = #imageLiteral(resourceName: "avatar")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())

    private lazy var editButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Edit"
        $0.configuration = config
        $0.addAction(UIAction { _ in self.callback?()},
                     for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))

    private let titleLabel: UILabel = {
        $0.text = "Enter your name and add an optional profile picture"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .secondaryLabel
        return $0
    }(UILabel())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {

    }

    public func configrure(with image: UIImage?) {
        photoImageView.image = image
    }
}
// MARK: - Setup
extension PhotoTableViewCell {
    private func setupViews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(editButton)
        contentView.addSubview(titleLabel)
    }

    private func setupConstraints() {
        photoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(55)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(60)
        }

        editButton.snp.makeConstraints {
            $0.centerX.equalTo(photoImageView)
            $0.top.equalTo(photoImageView.snp.bottom).offset(5)
            $0.height.equalTo(22)
            $0.bottom.equalToSuperview().inset(14)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(photoImageView)
            $0.leading.equalTo(photoImageView.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
@available (iOS 17.0, *)
#Preview {
    PhotoTableViewCell()
}
