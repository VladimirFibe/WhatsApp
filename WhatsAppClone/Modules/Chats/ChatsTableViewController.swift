import UIKit

final class ChatsTableViewController: UITableViewController {
    private var recents: [Recent] = [] { didSet { tableView.reloadData() }}
    private var searchResultController = ChatsSearchResultsViewController()
    private lazy var searchController = UISearchController(searchResultsController: searchResultController)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ChatsCell.self, forCellReuseIdentifier: ChatsCell.identifier)
        setupSearchConroller()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(addButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadRecentChats()
    }
    
    @objc private func addButtonTapped() {
        let controller = UsersViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func pushChat(_ recent: Recent) {
        let controller = ChatViewController(recent: recent)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func downloadRecentChats() {
        FirebaseClient.shared.downloadRecentChatsFromFireStore { recents in
            DispatchQueue.main.async {
                self.recents = recents
            }
        }
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recent = recents[indexPath.row]
            FirebaseClient.shared.deleteRecent(recent)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recent = recents[indexPath.row]
        pushChat(recent)
    }
    
    private func setupSearchConroller() {
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
        searchResultController.recents = text.isEmpty ? recents : recents.filter { $0.name.lowercased().contains(text)}
        searchResultController.pushChat = { [weak self] recent in self?.pushChat(recent)}
    }
}
