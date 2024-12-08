import UIKit
import FirebaseAuth

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let chats = ChatsTableViewController()
        let channels = ChannelsViewController()
        let users = UsersViewController()
        let settings = SettingsViewController()
        chats.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message"), tag: 0)
        channels.tabBarItem = UITabBarItem(title: "Channels", image: UIImage(systemName: "quote.bubble"), tag: 1)
        users.tabBarItem = UITabBarItem(title: "Users", image: UIImage(systemName: "person.2"), tag: 2)
        settings.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 3)
        setViewControllers([
            UINavigationController(rootViewController: chats),
            UINavigationController(rootViewController: channels),
            UINavigationController(rootViewController: users),
            UINavigationController(rootViewController: settings)
        ], animated: true)
    }
}

