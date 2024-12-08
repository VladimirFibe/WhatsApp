import UIKit

final class UsersSearchResultsViewController: UITableViewController {
    public var persons: [Person] = [] { didSet { tableView.reloadData() }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: UsersTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        persons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier, for: indexPath) as? UsersTableViewCell else { fatalError() }
        let person = persons[indexPath.row]
        cell.configure(with: person)
        return cell
    }
}
