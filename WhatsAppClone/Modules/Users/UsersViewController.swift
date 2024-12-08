import UIKit

final class UsersViewController: UITableViewController {
    private var bag = Bag()
    private let store = UsersStore()
    private var persons: [Person] = [] { didSet { tableView.reloadData() }}
    private let searchResultsController = UsersSearchResultsViewController()
    private lazy var searchController = UISearchController(searchResultsController: searchResultsController)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Users"
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: UsersTableViewCell.identifier)
        setupObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.sendAction(.fetch)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        persons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UsersTableViewCell.identifier,
            for: indexPath
        ) as? UsersTableViewCell else { fatalError() }
        let person = persons[indexPath.row]
        cell.configure(with: person)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let person = persons[indexPath.row]
        let contoller = ProfileViewController(person: person)
        contoller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(contoller, animated: true)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let isRefreshing = refreshControl?.isRefreshing, isRefreshing {
            store.sendAction(.fetch)
            refreshControl?.endRefreshing()
        }
    }
    
    private func setupObservers() {
        store
            .events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .done(let persons): self.persons = persons
                }
            }
            .store(in: &bag)
    }
}

extension UsersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        searchResultsController.persons = persons.filter({ $0.username.lowercased().contains(text)})
    }
}
