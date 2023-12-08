import UIKit

class AddPhotoChannelCell: BaseTableViewCell {
    static let identifier = "AddPhotoChannelCell"

    private let photoImageView: UIImageView = {
        $0.image = #imageLiteral(resourceName: "avatar")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 30
        $0.isUserInteractionEnabled = true
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())

    private let textField: UITextField = {
        $0.placeholder = "Channel"
        $0.borderStyle = .none
        return $0
    }(UITextField())

    var text: String {
        textField.text ?? ""
    }

    var image: UIImage? {
        photoImageView.image
    }

    func configure(_ gestureRecoginzer: UIGestureRecognizer) {
        photoImageView.addGestureRecognizer(gestureRecoginzer)
    }

    func configure(with image: UIImage?) {
        photoImageView.image = image
    }
}
// MARK: - Setup
extension AddPhotoChannelCell {
    override func setupViews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(textField)
        selectionStyle = .none
    }

    override func setupConstraints() {
        photoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(60)
            $0.bottom.equalToSuperview().inset(16)
        }

        textField.snp.makeConstraints {
            $0.leading.equalTo(photoImageView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
