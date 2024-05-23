import UIKit

class ChatsTableViewController: UITableViewController {
    var recents: [Recent] = []
    var filtered: [Recent] = []
    let searchController = UISearchController(searchResultsController: nil)
    //MARK: - Download Chats
    private func downloadRecentChats() {
        FirebaseClient.shared.downloadRecentChatsFromFireStore { recents in
            self.recents = recents
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadRecentChats()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

extension ChatsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchController.isActive ? filtered.count : recents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatsCell.identifier, for: indexPath) as? ChatsCell 
        else { fatalError("kapets")}
        let recent = searchController.isActive ? filtered[indexPath.row] : recents[indexPath.row]
        cell.configure(with: recent)
        return cell
    }
}

extension ChatsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recent = recents[indexPath.row]
        pushChat(recent)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recent = searchController.isActive ? filtered[indexPath.row] : recents[indexPath.row]
            FirebaseClient.shared.deleteRecent(recent)
        }
    }
}

extension ChatsTableViewController {
    private func setupViews() {
        tableView.register(ChatsCell.self, forCellReuseIdentifier: ChatsCell.identifier)
        setupAddButton()
        setupSearchController()
    }

    private func setupAddButton() {
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true

        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search user"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
}

extension ChatsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        filtered = text.isEmpty ? recents : recents.filter { $0.name.lowercased().contains(text)}
        tableView.reloadData()
    }
}
// MARK: - Actions
extension ChatsTableViewController {
    @objc private func addButtonTapped() {
        let controller = UsersViewControlller()
        navigationController?.pushViewController(controller, animated: true)
    }

    private func pushChat(_ recent: Recent) {
        let controller = ChatViewController(recent: recent)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}
