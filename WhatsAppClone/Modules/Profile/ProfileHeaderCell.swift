import UIKit

final class ProfileHeaderCell: UITableViewCell {
    static let identifier = "ProfileHeaderCell"
    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let statusLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupAvatarImageView()
        setupUsernameLabel()
        setupStatusLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with person: Person) {
        usernameLabel.text = person.username
        statusLabel.text = person.status.text
        FileStorage.downloadImage(id: person.id, link: person.avatarLink) { image in
            self.avatarImageView.image = image?.circleMasked
        }
    }
    
    private func setupAvatarImageView() {
        contentView.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.image = .avatar
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: contentView.readableContentGuide.topAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor)
        ])
    }
    
    private func setupUsernameLabel() {
        contentView.addSubview(usernameLabel)
        usernameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        usernameLabel.textAlignment = .center
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor)
        ])
    }
    
    private func setupStatusLabel() {
        contentView.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .secondaryLabel
        statusLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            statusLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.readableContentGuide.bottomAnchor)
        ])
    }
}

#Preview {
    UINavigationController(rootViewController: ProfileViewController(person: Person(id: "dI8suFNYoPagygLAbtXUge9hGhF2", username: "Jhon", email: "Motiw@icloud.com", avatarLink: "https://firebasestorage.googleapis.com:443/v0/b/whatsappclone-78758.appspot.com/o/profile%2FdI8suFNYoPagygLAbtXUge9hGhF2.jpg?alt=media&token=d4ea3134-ac58-44c4-ab98-608676462155")))
}
