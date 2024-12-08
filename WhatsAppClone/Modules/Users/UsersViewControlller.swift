import UIKit

final class UsersViewControlller: UITableViewController {
    private var persons: [Person] = [Person(id: "dI8suFNYoPagygLAbtXUge9hGhF2", username: "Jhon", email: "Motiw@icloud.com", avatarLink: "https://firebasestorage.googleapis.com:443/v0/b/whatsappclone-78758.appspot.com/o/profile%2FdI8suFNYoPagygLAbtXUge9hGhF2.jpg?alt=media&token=d4ea3134-ac58-44c4-ab98-608676462155")]
    
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

#Preview {
    UsersViewControlller()
}
