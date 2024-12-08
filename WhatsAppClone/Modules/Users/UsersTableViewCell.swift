import UIKit

final class UsersTableViewCell: UITableViewCell {
    static let identifier = "UsersTableViewCell"
    
    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let statusLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAvatarImageView()
        setupUsernameLabel()
        setupStatusLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAvatarImageView() {
        contentView.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 52),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.topAnchor.constraint(equalTo: contentView.readableContentGuide.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.readableContentGuide.bottomAnchor)
        ])
    }
    
    private func setupUsernameLabel() {
        contentView.addSubview(usernameLabel)
        usernameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor)
        ])
    }
    
    private func setupStatusLabel() {
        contentView.addSubview(statusLabel)
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .secondaryLabel
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            statusLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            statusLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor)
        ])
    }
    
    public func configure(with person: Person) {
        usernameLabel.text = person.username
        statusLabel.text = person.status.text
        FileStorage.downloadImage(id: person.id, link: person.avatarLink) {[weak self] image in
            self?.avatarImageView.image = image?.circleMasked
        }
    }
}

#Preview {
    UsersViewControlller()
}
