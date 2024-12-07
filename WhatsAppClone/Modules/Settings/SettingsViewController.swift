import UIKit

final class SettingsViewController: UITableViewController {
    private let store = SettingsStore()
    private var bag = Bag()
    private let userInfoCell = SettingsNameTableViewCell()
    private var person: Person? { didSet { showUserInfo() }}
    private var footerLabel: UILabel = {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        label.text = "WhatsApp from FaceBook\nApp version \(appVersion)"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        setupObservers()
        tableView.tableFooterView = footerLabel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.sendAction(.fetch)
    }
    
    @objc private func done() {
        store.sendAction(.signOut)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        userInfoCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = EditProfileViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    private func setupObservers() {
        store
            .events
            .receive(on: DispatchQueue.main)
            .sink {[weak self] event in
                switch event {
                case .done(let person): self?.person = person
                }
            }.store(in: &bag)
    }

    private func showUserInfo() {
        if let person {
            userInfoCell.configure(with: person)
            FileStorage.downloadImage(id: person.id, link: person.avatarLink) { image in
                self.userInfoCell.configure(with: image?.circleMasked)
            }
        }
    }
}
