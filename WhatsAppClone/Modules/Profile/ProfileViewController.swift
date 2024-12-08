import UIKit

final class ProfileViewController: UITableViewController {
    private let person: Person
    private let headerCell = ProfileHeaderCell()

    init(person: Person) {
        self.person = person
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = person.username
        headerCell.configure(with: person)
    }
    
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
            var config = cell.defaultContentConfiguration()
            config.text = "Start Chat"
            cell.contentConfiguration = config
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            print("Start chat")
        }
    }
}

#Preview {
    UINavigationController(rootViewController: ProfileViewController(person: Person(id: "dI8suFNYoPagygLAbtXUge9hGhF2", username: "Jhon", email: "Motiw@icloud.com", avatarLink: "https://firebasestorage.googleapis.com:443/v0/b/whatsappclone-78758.appspot.com/o/profile%2FdI8suFNYoPagygLAbtXUge9hGhF2.jpg?alt=media&token=d4ea3134-ac58-44c4-ab98-608676462155")))
}
