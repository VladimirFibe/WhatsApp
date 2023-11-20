import UIKit

final class UsersViewControlller: BaseViewController {
    private let useCase = UsersUseCase(apiService: FirebaseClient.shared)
    private lazy var store = UsersStore(useCase: useCase)
    var persons: [Person] = []
    var filtered: [Person] = []

    private let searchController = UISearchController()

    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.register(UsersTableViewCell.self, forCellReuseIdentifier: UsersTableViewCell.identifier)
        return $0
    }(UITableView())
}

extension UsersViewControlller {
    override func setupViews() {
        super.setupViews()
        navigationItem.title = "Users"
        view.addSubview(tableView)
        store.sendAction(.fetch)
        setupObservers()
        setupSearchController()
        tableView.refreshControl = UIRefreshControl()
    }

    private func setupObservers() {
        store
            .events
            .receive(on: DispatchQueue.main)
            .sink { event in
                weak var wSelf = self
                switch event {
                case .done(let persons):
                    wSelf?.persons = persons
                    wSelf?.tableView.reloadData()
                }
            }.store(in: &bag)
    }

    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }

    override func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if tableView.refreshControl!.isRefreshing {
            store.sendAction(.fetch)
            tableView.refreshControl!.endRefreshing()
        }
    }
}

extension UsersViewControlller: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filteredContentForSearchText(text.lowercased())
    }

    private func filteredContentForSearchText(_ text: String) {
        filtered = text.isEmpty ? persons : persons.filter { $0.username.lowercased().contains(text)}
        tableView.reloadData()
    }

}

extension UsersViewControlller: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchController.isActive ? filtered.count : persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier, for: indexPath) as? UsersTableViewCell else { fatalError()}
        let person = searchController.isActive ? filtered[indexPath.row] : persons[indexPath.row]
        cell.configure(with: person)
        return cell
    }
}

extension UsersViewControlller: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = ProfileViewController()
        controller.person = searchController.isActive ? filtered[indexPath.row] : persons[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
