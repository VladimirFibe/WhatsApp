import UIKit

final class DetailAboutChannelCell: BaseTableViewCell {
    private let titleLabel: UILabel = {
        $0.text = "About Channel"
        return $0
    }(UILabel())

    private let aboutLabel: UILabel = {
        $0.text = "Channel info ..."
        return $0
    }(UILabel())

    func configure(with channel: Channel) {
        aboutLabel.text = channel.aboutChannel
    }
}
// MARK: - Setup Views
extension DetailAboutChannelCell {
    override func setupViews() {
        super.setupViews()
        contentView.addSubview(titleLabel)
        contentView.addSubview(aboutLabel)
        selectionStyle = .none
    }

    override func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        aboutLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}
