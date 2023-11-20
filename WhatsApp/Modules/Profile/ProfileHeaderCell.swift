import UIKit

class ProfileHeaderCell: BaseTableViewCell {

    static let identifier = "ProfileHeaderCell"
    
    private let avatarImageView: UIImageView = {
        $0.image = #imageLiteral(resourceName: "avatar")
        return $0
    }(UIImageView())

    private let usernameLabel: UILabel = {
        $0.text = "username"
        $0.textAlignment = .center
        return $0
    }(UILabel())

    private let statusLabel: UILabel = {
        $0.text = "status"
        $0.textAlignment = .center
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

extension ProfileHeaderCell {
    override func setupViews() {
        super.setupViews()
        [avatarImageView, usernameLabel, statusLabel].forEach { contentView.addSubview($0)}
    }

    override func setupConstraints() {
        super.setupConstraints()
        avatarImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }

        usernameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        statusLabel.snp.makeConstraints {
            $0.top.equalTo(usernameLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(usernameLabel)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
}
