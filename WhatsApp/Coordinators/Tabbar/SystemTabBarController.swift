import UIKit

final class SystemTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true
    }
}
