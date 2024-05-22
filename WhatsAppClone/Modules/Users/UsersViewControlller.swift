import UIKit

class UsersViewControlller: UITableViewController {
    private var bag = Bag()
    private let store = UsersStore()
    var persons: [Person] = []
    var filteredPersons: [Person] = []
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}
// MARK: - Setup Views
extension UsersViewControlller {
    private func setupViews() {
        navigationItem.title = "Users"
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        store.sendAction(.fetch)
        setupObservers()
        setupSeachController()
        tableView.register(UsersTableViewCell.self,
                           forCellReuseIdentifier: UsersTableViewCell.identifier)
    }

    private func setupSeachController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true

        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        searchController.searchResultsUpdater = self

        definesPresentationContext = true
    }

    private func setupObservers() {
        store
            .events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .done(let persons):
                    self.persons = persons
                    self.tableView.reloadData()
                }
            }
            .store(in: &bag)
    }
}
// MARK: -
extension UsersViewControlller {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchController.isActive ? filteredPersons.count : persons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier, for: indexPath) as? UsersTableViewCell else {
            return UITableViewCell()
        }
        let person = searchController.isActive ? filteredPersons[indexPath.row] : persons[indexPath.row]
        cell.configure(with: person)
        return cell
    }
}
// MARK: -
extension UsersViewControlller {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let person = searchController.isActive ? filteredPersons[indexPath.row] : persons[indexPath.row]
        let controller = ProfileViewController(person: person)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}
// MARK: -
extension UsersViewControlller {
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let isRefreshing = refreshControl?.isRefreshing, isRefreshing {
            store.sendAction(.fetch)
            refreshControl?.endRefreshing()
        }
    }
}
// MARK: - UISearchResultsUpdating
extension UsersViewControlller: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        filteredPersons = text.isEmpty ? persons : persons.filter({ $0.username.lowercased().contains(text)})
        tableView.reloadData()
    }
}
