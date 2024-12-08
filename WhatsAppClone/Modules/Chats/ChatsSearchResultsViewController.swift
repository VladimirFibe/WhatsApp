import UIKit

final class ChatsSearchResultsViewController: UITableViewController {
    public var recents: [Recent] = [] { didSet { tableView.reloadData() }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ChatsCell.self, forCellReuseIdentifier: ChatsCell.identifier)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatsCell.identifier,
            for: indexPath
        ) as? ChatsCell else { fatalError() }
        let recent = recents[indexPath.row]
        cell.configure(with: recent)
        return cell
    }
}
