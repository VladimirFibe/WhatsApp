import UIKit

class ChatsCell: BaseTableViewCell {

    static let identifier = "ChatsCell"

    private let avatarImageView: UIImageView = {
        $0.image = #imageLiteral(resourceName: "avatar")
        return $0
    }(UIImageView())

    private let usernameLabel: UILabel = {
        $0.text = "username"
        return $0
    }(UILabel())

    private let lastMessageLabel: UILabel = {
        $0.text = "status"
        return $0
    }(UILabel())

    private let dateLabel: UILabel = {
        let date = Date()
        $0.text = date.timeElapsed()
        return $0
    }(UILabel())

    private lazy var unreadCounterLabel: UILabel = {
        $0.text = "99"
        $0.textAlignment = .center
        $0.backgroundColor = .systemGreen
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        return $0
    }(UILabel())

    public func configure(with chat: RecentChat) {

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
