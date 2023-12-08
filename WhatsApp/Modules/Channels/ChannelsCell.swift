import UIKit

final class ChannelsCell: BaseTableViewCell {

    static let identifier = "ChannelsCell"

    private let avatarImageView: UIImageView = {
        $0.image = #imageLiteral(resourceName: "avatar")
        return $0
    }(UIImageView())

    private let nameLabel: UILabel = {
        $0.text = "Channel Name"
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.9
        return $0
    }(UILabel())

    private let aboutChannelLabel: UILabel = {
        $0.text = "Last Message"
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.9
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    private let membersLabel: UILabel = {
        $0.text = "Members: 1000"
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.9
        return $0
    }(UILabel())

    private let dateLabel: UILabel = {
        $0.text = "10:41"
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.9
        return $0
    }(UILabel())

    public func configure(with channel: Channel) {
        nameLabel.text = channel.name
        aboutChannelLabel.text = channel.aboutChannel
        membersLabel.text = "\(channel.memberIds.count) members"
        dateLabel.text = timeElapsed(channel.lastMessageDate ?? Date())
        if let id = channel.id {
            setAvatar(id: id, link: channel.avatarLink)
        }
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
        accessoryType = .disclosureIndicator
        [avatarImageView, nameLabel, aboutChannelLabel, membersLabel, dateLabel].forEach { contentView.addSubview($0)}
    }

    override func setupConstraints() {
        super.setupConstraints()
        avatarImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.size.equalTo(60)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageView.snp.top)
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
        }

        aboutChannelLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalTo(nameLabel)
        }

        membersLabel.snp.makeConstraints {
            $0.top.equalTo(aboutChannelLabel.snp.bottom).offset(2)
            $0.leading.equalTo(nameLabel)
        }

        dateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.equalTo(membersLabel.snp.trailing).offset(8)
        }
    }
}
