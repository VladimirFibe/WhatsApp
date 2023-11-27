import UIKit

class ChatsCell: BaseTableViewCell {

    static let identifier = "ChatsCell"

    private let avatarImageView: UIImageView = {
        $0.image = #imageLiteral(resourceName: "avatar")
        return $0
    }(UIImageView())

    private let usernameLabel: UILabel = {
        $0.text = "username"
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.9
        return $0
    }(UILabel())

    private let lastMessageLabel: UILabel = {
        $0.text = "status"
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.9
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    private let dateLabel: UILabel = {
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.9
        return $0
    }(UILabel())

    private lazy var unreadCounterLabel: UILabel = {
        $0.textAlignment = .center
        $0.backgroundColor = .systemGreen
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        return $0
    }(UILabel())

    public func configure(with recent: RecentChat) {
        usernameLabel.text = recent.receiverName
        lastMessageLabel.text = recent.lastMessage
        dateLabel.text = recent.date?.timeElapsed()
        if recent.unreadCounter != 0 {
            unreadCounterLabel.text = "\(recent.unreadCounter)"
            unreadCounterLabel.isHidden = false
        } else {
            unreadCounterLabel.isHidden = true
        }
        setAvatar(id: recent.receiverId, link: recent.avatarLink)
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

extension ChatsCell {
    override func setupViews() {
        super.setupViews()
        [avatarImageView, usernameLabel, lastMessageLabel, dateLabel, unreadCounterLabel].forEach { contentView.addSubview($0)}
    }

    override func setupConstraints() {
        super.setupConstraints()
        avatarImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.size.equalTo(60)
        }

        usernameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageView)
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(8)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageView)
            $0.leading.equalTo(usernameLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }


        lastMessageLabel.snp.makeConstraints {
            $0.top.equalTo(usernameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(usernameLabel)
            $0.bottom.equalToSuperview().inset(8)
        }

        unreadCounterLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.size.equalTo(30)
            $0.leading.equalTo(lastMessageLabel.snp.trailing).offset(8)
        }
    }
}
