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
        let url = URL(string: "https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=1800&t=st=1695795355~exp=1695795955~hmac=3a280c81162b0e108f5f469da1e810209d8868e84296bc5bdc6cce47a0175b13")
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
