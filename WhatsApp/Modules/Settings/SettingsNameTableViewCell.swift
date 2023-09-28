import UIKit
import Kingfisher

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
    
    public func configure(with person: LocalPerson) {
        let url = URL(string: "https://firebasestorage.googleapis.com:443/v0/b/whatsappclone-78758.appspot.com/o/profile%2FF24EBA1C-9B6A-4095-B528-D34236CB9178?alt=media&token=835b8686-9adc-4c38-91e7-ffdc8f0284b9")
        photoImageView.kf.setImage(with: url)
        titleLabel.text = person.username
        subtitleLabel.text = person.status
    }
}
// MARK: - Setup
extension SettingsNameTableViewCell {
    override func setupViews() {
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
