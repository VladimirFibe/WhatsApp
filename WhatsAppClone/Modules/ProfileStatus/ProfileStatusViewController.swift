import UIKit

final class ProfileStatusViewController: UITableViewController {
    private var callback: (Person.Status) -> Void
    private var status: Person.Status
    
    init(status: Person.Status, callback: @escaping (Person.Status) -> Void) {
        self.status = status
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        status.statuses.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = status.statuses[indexPath.row]
        cell.contentConfiguration = config
        cell.accessoryType = indexPath.row == status.index ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        status.index = indexPath.row
        callback(status)
        navigationController?.popViewController(animated: true)
    }
}
