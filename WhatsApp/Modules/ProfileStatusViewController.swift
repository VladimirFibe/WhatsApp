import UIKit

final class ProfileStatusViewController: BaseViewController {
    var allStatuses: [String] = Status.allCases.map {$0.rawValue}
    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return $0
    }(UITableView())
}

extension ProfileStatusViewController {
    override func setupViews() {
        super.setupViews()
        view.addSubview(tableView)
    }

    override func setupConstraints() {
        tableView.snp.makeConstraints { $0.edges.equalToSuperview()}
    }
}

extension ProfileStatusViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allStatuses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = allStatuses[indexPath.row]
        return cell
    }
    

}
