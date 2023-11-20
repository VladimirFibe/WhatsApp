import UIKit

final class UsersViewControlller: BaseViewController {
    private let useCase = UsersUseCase(apiService: FirebaseClient.shared)
    private lazy var store = UsersStore(useCase: useCase)
    var persons: [Person] = []
    var filtered: [Person] = []

    private let seachController = UISearchController()

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

    override func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension UsersViewControlller: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        seachController.isActive ? filtered.count : persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier, for: indexPath) as? UsersTableViewCell else { fatalError()}
        let person = seachController.isActive ? filtered[indexPath.row] : persons[indexPath.row]
        cell.configure(with: person)
        return cell
    }
}

extension UsersViewControlller: UITableViewDelegate {

}
