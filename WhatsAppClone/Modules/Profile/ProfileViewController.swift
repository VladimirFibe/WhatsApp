import UIKit

final class ProfileViewController: UITableViewController {
    private let person: Person
    private let headerCell = ProfileHeaderCell()
    init(person: Person) {
        self.person = person
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileViewController {
    private func setupViews() {
        headerCell.configure(with: person)
        navigationItem.title = person.username
    }
}

extension ProfileViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return headerCell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Start Chart"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
}
// MARK: -
extension ProfileViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let recent = Recent(name: person.username, avatarLink: person.avatarLink, chatRoomId: person.id)
            let controller = ChatViewController(recent: recent)
            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
