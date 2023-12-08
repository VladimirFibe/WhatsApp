import UIKit

class AddPhotoChannelCell: BaseTableViewCell {
    static let identifier = "AddPhotoChannelCell"

    private let photoImageView: UIImageView = {
        $0.image = #imageLiteral(resourceName: "avatar")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())

    private let textField: UITextField = {
        $0.placeholder = "Channel"
        $0.borderStyle = .none
        return $0
    }(UITextField())

//    private let editButton: UIButton = {
//        $0.setTitle("Edit", for: [])
//        return $0
//    }(UIButton(type: .system))
//
//    private let titleLabel: UILabel = {
//        $0.text = "Enter your name and add an optional profile picture"
//        $0.numberOfLines = 0
//        $0.font = .systemFont(ofSize: 12)
//        $0.textColor = .secondaryLabel
//        return $0
//    }(UILabel())
//
//    public func configure(_ target: Any?, action: Selector) {
//        editButton.addTarget(
//            target, action:
//                action,
//            for: .primaryActionTriggered
//        )
//    }
//
//    public func configrure(with image: UIImage?) {
//        photoImageView.image = image
//    }
}
// MARK: - Setup
extension AddPhotoChannelCell {
    override func setupViews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(textField)
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
