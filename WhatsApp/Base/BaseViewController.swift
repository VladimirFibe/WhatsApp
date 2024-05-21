import UIKit

class BaseViewController: UIViewController {
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

@objc extension BaseViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
    }
    func setupConstraints() {}
}
