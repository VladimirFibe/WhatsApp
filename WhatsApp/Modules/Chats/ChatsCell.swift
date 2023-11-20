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

    private let statusLabel: UILabel = {
        $0.text = "status"
        return $0
    }(UILabel())

    public func configure(with person: Person) {
        usernameLabel.text = person.username
        statusLabel.text = person.status
        FileStorage.downloadImage(person: person) { image in
            self.avatarImageView.image = image?.circleMasked
        }
    }
}

extension ChatsCell {
    override func setupViews() {
        super.setupViews()
        [avatarImageView, usernameLabel, statusLabel].forEach { contentView.addSubview($0)}
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
            $0.trailing.equalToSuperview().inset(16)
        }

        statusLabel.snp.makeConstraints {
            $0.top.equalTo(usernameLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(usernameLabel)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
}
