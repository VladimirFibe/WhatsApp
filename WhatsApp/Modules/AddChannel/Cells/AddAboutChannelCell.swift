import UIKit

final class AddAboutChannelCell: BaseTableViewCell {
    private let titleLabel: UILabel = {
        $0.text = "About Channel"
        return $0
    }(UILabel())

    private let textView: UITextView = {
        $0.text = "Channel info ..."
        return $0
    }(UITextView())

    var text: String {
        textView.text ?? ""
    }

    func configure(with channel: Channel) {
        textView.text = channel.aboutChannel
    }
}
// MARK: - Setup Views
extension AddAboutChannelCell {
    override func setupViews() {
        super.setupViews()
        contentView.addSubview(titleLabel)
        contentView.addSubview(textView)
    }

    override func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        textView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(100)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}
