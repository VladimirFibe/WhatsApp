import UIKit

class SettingsNameTableViewCell: BaseTableViewCell {
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
//        let url = URL(string: person.avatarLink)
//        photoImageView.kf.setImage(with: url)
        titleLabel.text = person.username
        subtitleLabel.text = person.status
    }

    public func configure(with image: UIImage?) {
        photoImageView.image = image
    }
}
// MARK: - Setup
extension SettingsNameTableViewCell {
    override func setupViews() {
        accessoryType = .disclosureIndicator
        [photoImageView, titleLabel, subtitleLabel]
            .forEach { contentView.addSubview($0)}
    }

    override func setupConstraints() {
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
