import UIKit

final class ChatsCell: UITableViewCell {
    static let identifier = "ChatsCell"
    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let lastMessageLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAvatarImageView()
        setupUsernameLabel()
        setupLastMessageLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with recent: Recent) {
        usernameLabel.text = recent.name
        lastMessageLabel.text = recent.text
        FileStorage.downloadImage(id: recent.chatRoomId, link: recent.avatarLink) { image in
            if let image {
                self.avatarImageView.image = image.circleMasked
            } else {
                self.avatarImageView.image = .avatar
            }
        }
    }
    
    private func setupAvatarImageView() {
        contentView.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.readableContentGuide.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.readableContentGuide.bottomAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
        ])
    }
    
    private func setupUsernameLabel() {
        contentView.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor)
        ])
    }
    
    private func setupLastMessageLabel() {
        contentView.addSubview(lastMessageLabel)
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lastMessageLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            lastMessageLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor)
        ])
    }
}
