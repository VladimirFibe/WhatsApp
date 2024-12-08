import UIKit

final class PhotoTableViewCell: UITableViewCell {
    private let photoImageView = UIImageView()
    private let editButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupPhotoImageView()
        setupEditButton()
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhotoImageView() {
        contentView.addSubview(photoImageView)
        photoImageView.image = .avatar
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = 30
        photoImageView.layer.masksToBounds = true
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 55),
            photoImageView.heightAnchor.constraint(equalToConstant: 60),
            photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor),
        ])
    }
    
    private func setupEditButton() {
        contentView.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Edit"
        editButton.configuration = configuration
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 5),
            editButton.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            editButton.heightAnchor.constraint(equalToConstant: 22),
            editButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14)
        ])
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.text = "Enter your name and add an optional profile picture"
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: photoImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    public func configure(with action: UIAction) {
        editButton.addAction(action, for: .primaryActionTriggered)
    }
    
    public func configure(with image: UIImage?) {
        photoImageView.image = image
    }
}
