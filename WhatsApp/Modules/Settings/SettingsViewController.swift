import UIKit
import ProgressHUD
import FirebaseAuth

final class SettingsViewController: BaseViewController {
    private let settingsUseCase = SettingsUseCase(apiService: FirebaseClient.shared)
    private lazy var store = SettingsStore(settingsUseCase: settingsUseCase)
    var callback: Callback?
    init(callback: Callback? = nil) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let rows: [[SettingsRowModel]] = [
        [.init(title: "", image: nil)],
        [.init(title: "Starred Message", image: #imageLiteral(resourceName: "settingStar.pdf")),
         .init(title: "WhatsApp Web/Desktop", image: #imageLiteral(resourceName: "settingDesktop.pdf"))],
        [.init(title: "Account", image: #imageLiteral(resourceName: "settingAccount.pdf")),
         .init(title: "Chats", image: #imageLiteral(resourceName: "settingChats.pdf")),
         .init(title: "Notifications", image: #imageLiteral(resourceName: "settingNotification.pdf")),
         .init(title: "Data and Storage Usage", image: #imageLiteral(resourceName: "settingData.pdf"))],
        [.init(title: "Help", image: #imageLiteral(resourceName: "settingHelp.pdf")),
         .init(title: "Tell a Fiend", image: #imageLiteral(resourceName: "settingShare.pdf"))]
    ]

    private let userInfoCell = SettingsNameTableViewCell()
    private let footerLabel: UILabel = {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        $0.text = "WhatsApp from Facebook\nApp version \(appVersion)"
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .secondaryLabel
        return $0
    }(UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 60)))

    private let tableview: UITableView = {
        $0.register(
            SettingsNameTableViewCell.self,
            forCellReuseIdentifier: SettingsNameTableViewCell.identifier
        )
        $0.register(
            SettingRowTableViewCell.self,
            forCellReuseIdentifier: SettingRowTableViewCell.identifier
        )
        return $0
    }(UITableView(frame: .zero, style: .grouped))

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.sendAction(.fetch)
    }
}
// MARK: - Setup
extension SettingsViewController {
    override func setupViews() {
        view.addSubview(tableview)
        tableview.dataSource = self
        tableview.delegate = self
        navigationItem.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(logout)
        )
        tableview.tableFooterView = footerLabel
        setupObservers()
    }

    private func setupObservers() {
        store
            .events
            .receive(on: DispatchQueue.main)
            .sink { event in
                weak var wSelf = self
                switch event {
                case .done:
                    wSelf?.showUserInfo()
                case .signOut:
                    wSelf?.callback?()
                }
            }.store(in: &bag)
    }

    override func setupConstraints() {
        tableview.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide)}
    }

    @objc private func logout() {
        store.sendAction(.signOut)
    }

    private func showUserInfo() {
        if let person = FirebaseClient.shared.person {
            userInfoCell.configure(with: person)
            guard let id = person.id else { return }
            FileStorage.downloadImage(id: id, link: person.avatarLink) { image in
                self.userInfoCell.configure(with: image?.circleMasked)
            }
        }
    }
}
// MARK: -
extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        rows.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return userInfoCell
        default:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingRowTableViewCell.identifier,
                for: indexPath
            ) as? SettingRowTableViewCell
            else { fatalError() }
            let model = rows[indexPath.section][indexPath.row]
            cell.configure(with: model)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
}
// MARK: -
extension SettingsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if indexPath.section == 0 {
            let controller = EditProfileViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
