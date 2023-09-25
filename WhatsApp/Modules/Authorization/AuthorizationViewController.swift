import UIKit
import SnapKit

class AuthorizationViewController: BaseViewController {
    private let titleLabel = {
        $0.text = "Login"
        $0.font = .systemFont(ofSize: 35)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var countryButton: UIButton = {
        $0.setTitle("Kazakhstan", for: [])
        $0.addTarget(self, action: #selector(countryButtonTapped), for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))

    @objc private func doneButtonTapped() {
        print(#function)
    }

    @objc private func countryButtonTapped() {
        print(#function)
    }
}

extension AuthorizationViewController {
    override func setupViews() {
        super.setupViews()
        [titleLabel, countryButton].forEach { view.addSubview($0)}
    }

    override func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        countryButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
    }
}
