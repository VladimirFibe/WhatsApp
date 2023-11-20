import UIKit
import FirebaseAuth

class ProfileViewController: BaseViewController {

    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        return $0
    }(UITableView())

    private let headerCell = ProfileHeaderCell()
}

extension ProfileViewController {
    override func setupViews() {
        super.setupViews()
        view.addSubview(tableView)
    }

    override func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ProfileViewController: UITableViewDelegate {

}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return headerCell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Start Chat"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
}
