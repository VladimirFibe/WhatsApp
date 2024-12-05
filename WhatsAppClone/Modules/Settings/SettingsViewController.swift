import UIKit

final class SettingsViewController: UITableViewController {
    private var callback: Callback?
    private let store = SettingsStore()
    private var bag = Bag()
    private let userInfoCell = SettingsNameTableViewCell()
    private var person: Person?
    
    init(callback: Callback? = nil) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        store.sendAction(.fetch)
        view.backgroundColor = .systemBackground
        navigationItem.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
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
}
