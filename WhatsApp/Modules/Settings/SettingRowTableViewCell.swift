import UIKit

class SettingRowTableViewCell: BaseTableViewCell {
    private let logoImageView: UIImageView = {
        return $0
    }(UIImageView())
    private let titleLabel: UILabel = {
        return $0
    }(UILabel())
    static let identifier = "SettingRowTableViewCell"
    public func configure(with model: SettingsRowModel) {
        logoImageView.image = model.image
        titleLabel.text = model.title
    }
}
// MARK: - Setup
extension SettingRowTableViewCell {
    override func setupViews() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)
    }

    override func setupConstraints() {
        logoImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().offset(15)
            $0.size.equalTo(29)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(logoImageView.snp.trailing).offset(15)
            $0.trailing.equalToSuperview()
        }
    }
}
