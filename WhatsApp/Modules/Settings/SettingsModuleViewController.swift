import UIKit
import FirebaseAuth

struct SettingsRowModel {
    let title: String
    let image: UIImage?
}

final class SettingsModuleViewController: BaseViewController {
    struct Model {
        let pushUnitHandler: (() -> Void)?
        let pushModuleHandler: (() -> Void)?
        let closeUnitOrModuleHandler: (() -> Void)?
        let popToRootHandler: (() -> Void)?
        let modalModuleHandler: (() -> Void)?
        let modalUnitHandler: (() -> Void)?
        let closeModalHandler: (() -> Void)?
    }
    private weak var output: AuthorizationModuleOutput?
    private let model: Model
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

    init(
        output: AuthorizationModuleOutput?,
        model: Model
    ) {
        self.model = model
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        print("SettingsModuleViewController dealloc")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Setup
extension SettingsModuleViewController {
    override func setupViews() {
        view.addSubview(tableview)
        tableview.dataSource = self
        navigationItem.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(logout))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        label.text = "WhatsApp from Facebook"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        tableview.tableFooterView = label
    }

    override func setupConstraints() {
        tableview.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide)}
    }

    @objc private func logout() {
        do {
            try Auth.auth().signOut()
            output?.moduleFinish()
        } catch {}
    }

    private func showUserInfo() {
//        if let person = Person.c
    }
}
// MARK: -
extension SettingsModuleViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingsNameTableViewCell.identifier,
                for: indexPath
            ) as? SettingsNameTableViewCell
            else { fatalError() }
            cell.accessoryType = .disclosureIndicator
            if let person = FirebaseClient.shared.currentPerson {
                cell.configure(with: person)
            }
            return cell
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
