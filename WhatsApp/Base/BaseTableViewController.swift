import UIKit

class BaseTableViewController: UITableViewController {
    var bag = Bag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    deinit {
        print("\(String(describing: self)) dealloc" )
    }
}

@objc extension BaseTableViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
    }
    func setupConstraints() {}
}
