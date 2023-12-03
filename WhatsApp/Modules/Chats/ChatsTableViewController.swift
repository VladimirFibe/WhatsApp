import UIKit

final class ChatsTableViewController: BaseTableViewController {
    var recents: [Recent] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadRecentChats()
        tableView.reloadData()
    }

    //MARK: - Download Chats
    private func downloadRecentChats() {
        FirebaseClient.shared.downloadRecentChatsFromFireStore { recents in
            self.recents = recents

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ChatsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatsCell.identifier, for: indexPath) as? ChatsCell else { fatalError() }
        cell.configure(with: recents[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension ChatsTableViewController {
    override func setupViews() {
        tableView.register(ChatsCell.self, forCellReuseIdentifier: ChatsCell.identifier)
    }
}

extension ChatsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = ChatViewController(recent: recents[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}
