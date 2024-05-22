import UIKit

class SettingsNameTableViewCell: UITableViewCell {
    static let identifier = "SettingsNameTableViewCell"

    private let photoImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 29
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())

    private let titleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 20)
        return $0
    }(UILabel())

    private let subtitleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .secondaryLabel
        return $0
    }(UILabel())

    public func configure(with person: Person) {
        titleLabel.text = person.username
        subtitleLabel.text = person.status.text
    }

    public func configure(with image: UIImage?) {
        photoImageView.image = image
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
// MARK: - Setup
extension SettingsNameTableViewCell {
    private func setupViews() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        [photoImageView, titleLabel, subtitleLabel]
            .forEach { contentView.addSubview($0)}
    }

    private func setupConstraints() {
        photoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.bottom.equalToSuperview().inset(9)
            $0.size.equalTo(58)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(photoImageView.snp.trailing).offset(12)
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(16)
        }
        subtitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom)
        }
    }
}

