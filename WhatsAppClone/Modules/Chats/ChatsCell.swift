import UIKit

final class ChatsCell: UITableViewCell {
    static let identifier = "ChatsCell"

    private let avatarImageView: UIImageView = {
        $0.image = .avatar
        return $0
    }(UIImageView())

    private let usernameLabel: UILabel = {
        return $0
    }(UILabel())

    private let lastMessageLabel: UILabel = {
        return $0
    }(UILabel())

    private let dateLabel: UILabel = {
        return $0
    }(UILabel())

    private let unreadCounterLabel: UILabel = {
        $0.textAlignment = .center
        $0.backgroundColor = .systemGreen
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        return $0
    }(UILabel())

    public func configure(with recent: Recent) {
        usernameLabel.text = recent.name
        lastMessageLabel.text = recent.text
        dateLabel.text = recent.date?.timeElapsed
        unreadCounterLabel.text = "\(recent.unreadCounter)"
        unreadCounterLabel.isHidden = recent.unreadCounter == 0
        FileStorage.downloadImage(id: recent.chatRoomId, link: recent.avatarLink) { image in
            if let image {
                self.avatarImageView.image = image.circleMasked
            } else {
                self.avatarImageView.image = .avatar
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatsCell {
    private func setupViews() {
        [avatarImageView, usernameLabel, lastMessageLabel, dateLabel, unreadCounterLabel].forEach {
            contentView.addSubview($0)
        }
        dateLabel.setContentHuggingPriority(.init(251), for: .horizontal)
    }

    private func setupConstraints() {
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
        }

        unreadCounterLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.size.equalTo(30)
            $0.leading.equalTo(lastMessageLabel.snp.trailing).offset(8)
        }
    }
}
