import UIKit

final class ChannelsCell: BaseTableViewCell {

    static let identifier = "ChannelsCell"

    private let avatarImageView: UIImageView = {
        $0.image = #imageLiteral(resourceName: "avatar")
        return $0
    }(UIImageView())

    private let nameLabel: UILabel = {
        $0.text = "username"
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.9
        return $0
    }(UILabel())

    private let aboutLabel: UILabel = {
        $0.text = "status"
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.9
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    private let membersLabel: UILabel = {
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.9
        return $0
    }(UILabel())

    private let dateLabel: UILabel = {
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.9
        return $0
    }(UILabel())

    public func configure() {
    }

    private func setAvatar(id: String, link: String) {
        FileStorage.downloadImage(id: id, link: link) { image in
            if let image {
                self.avatarImageView.image = image.circleMasked
            } else {
                self.avatarImageView.image = #imageLiteral(resourceName: "avatar")
            }
        }
    }
}

extension ChannelsCell {
    override func setupViews() {
        super.setupViews()
        [avatarImageView, nameLabel, aboutLabel, membersLabel, dateLabel].forEach { contentView.addSubview($0)}
    }

    override func setupConstraints() {
        super.setupConstraints()
        avatarImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.size.equalTo(60)
        }
    }
}
