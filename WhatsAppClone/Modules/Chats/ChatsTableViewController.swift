import UIKit

final class ChatsTableViewController: UITableViewController {
    private var recents: [Recent] = []
    private var filteredRecents: [Recent] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ChatsCell.self, forCellReuseIdentifier: ChatsCell.identifier)
        setupSearchConroller()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadRecentChats()
    }
    
    private func downloadRecentChats() {
        FirebaseClient.shared.downloadRecentChatsFromFireStore { recents in
            DispatchQueue.main.async {
                self.recents = recents
                self.tableView.reloadData()
                print(recents.count)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchController.isActive ? filteredRecents.count : recents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatsCell.identifier, for: indexPath) as? ChatsCell else { fatalError() }
        let recent = searchController.isActive ? filteredRecents[indexPath.row] : recents[indexPath.row]
        cell.configure(with: recent)
        return cell
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
        filteredRecents = text.isEmpty ? recents : recents.filter { $0.name.lowercased().contains(text)}
        tableView.reloadData()
    }
}
