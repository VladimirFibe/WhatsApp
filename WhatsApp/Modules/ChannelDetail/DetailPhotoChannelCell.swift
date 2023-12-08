import UIKit

class DetailPhotoChannelCell: BaseTableViewCell {
    static let identifier = "DetailPhotoChannelCell"

    private let photoImageView: UIImageView = {
        $0.image = #imageLiteral(resourceName: "avatar")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 30
        $0.isUserInteractionEnabled = true
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())

    private let nameLabel: UILabel = {
        $0.text = "Channel"
        return $0
    }(UILabel())

    func configure(with channel: Channel) {
        nameLabel.text = channel.name
        setAvatar(id: channel.id, link: channel.avatarLink)
    }

    private func setAvatar(id: String, link: String) {
        FileStorage.downloadImage(id: id, link: link) { image in
            if let image {
                self.photoImageView.image = image.circleMasked
            }
        }
    }
}
// MARK: - Setup
extension DetailPhotoChannelCell {
    override func setupViews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        selectionStyle = .none
    }

    override func setupConstraints() {
        photoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(60)
            $0.bottom.equalToSuperview().inset(16)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(photoImageView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
