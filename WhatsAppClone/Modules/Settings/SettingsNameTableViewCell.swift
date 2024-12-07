import UIKit

final class SettingsNameTableViewCell: UITableViewCell {
    static let identifier = "SettingsNameTableViewCell"
    private let photoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with person: Person) {
        titleLabel.text = person.username
        subtitleLabel.text = person.status.text
    }
    
    public func configure(with image: UIImage?) {
        photoImageView.image = image
    }
    
    private func setupViews() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        setupPhotoImageView()
        setupTitleLabel()
        setupSubtitleLabel()
    }
    
    private func setupPhotoImageView() {
        addSubview(photoImageView)
        photoImageView.backgroundColor = .red
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = 29
        photoImageView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            photoImageView.widthAnchor.constraint(equalToConstant: 58),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),
            photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.text = "Text"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setupSubtitleLabel() {
        addSubview(subtitleLabel)
        subtitleLabel.text = "Free"
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }
}
