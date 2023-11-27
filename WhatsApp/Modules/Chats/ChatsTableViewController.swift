import UIKit

final class ChatsTableViewController: BaseTableViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension ChatsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatsCell.identifier, for: indexPath) as? ChatsCell else { fatalError() }
        cell.configure(with: RecentChat())
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
        print(indexPath.row)
    }
}
