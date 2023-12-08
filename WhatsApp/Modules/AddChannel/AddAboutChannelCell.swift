import UIKit

final class AddAboutChannelCell: BaseTableViewCell {
    private let titleLabel: UILabel = {
        $0.text = "Title"
        return $0
    }(UILabel())
}
// MARK: - Setup Views
extension AddAboutChannelCell {
    override func setupViews() {
        super.setupViews()
        contentView.addSubview(titleLabel)
    }

    override func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}
