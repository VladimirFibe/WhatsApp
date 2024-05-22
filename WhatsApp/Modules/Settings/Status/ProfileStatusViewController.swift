import UIKit

final class ProfileStatusViewController: BaseViewController {
    private let useCase = ProfileStatusUseCase(apiService: FirebaseClient.shared)
    private lazy var store = ProfileStatusStore(useCase: useCase)
    var allStatuses: [String] = Status.statuses
    var currentStatus = FirebaseClient.shared.person?.status ?? ""
    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return $0
    }(UITableView())
}

extension ProfileStatusViewController {
    override func setupViews() {
        super.setupViews()
        view.addSubview(tableView)
        navigationItem.title = "Status"
        firstRunCheck()
    }

    override func setupConstraints() {
        tableView.snp.makeConstraints { $0.edges.equalToSuperview()}
    }

    private func firstRunCheck() {
        if allStatuses.isEmpty {
            allStatuses = Status.allCases.map {$0.rawValue}
            Status.statuses = allStatuses
            //TODO: проверить нужен ли reloadData()
        }
    }
}

extension ProfileStatusViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allStatuses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let status = allStatuses[indexPath.row]
        cell.textLabel?.text = status
        cell.accessoryType = currentStatus == status ? .checkmark : .none
        return cell
    }
}

extension ProfileStatusViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        currentStatus = allStatuses[indexPath.row]
        store.sendAction(.updateStatus(currentStatus))
        navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
}
