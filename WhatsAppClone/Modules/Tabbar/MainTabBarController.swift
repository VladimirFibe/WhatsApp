import UIKit

class MainTabBarController: UITabBarController {
    public var callback: Callback?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabBar()
    }

    private func setupTabBar() {
        view.backgroundColor = .systemBackground
        let chats = UINavigationController(rootViewController: ChatsTableViewController())
        let channels = UINavigationController(rootViewController: ChannelsViewController())
        let users = UINavigationController(rootViewController: UsersViewControlller())
        let settings = UINavigationController(rootViewController: makeSettings())

        chats.tabBarItem = tabItem(for: .chats)
        channels.tabBarItem = tabItem(for: .channels)
        users.tabBarItem = tabItem(for: .users)
        settings.tabBarItem = tabItem(for: .settings)
        setViewControllers([chats, channels, users, settings], animated: true)
        selectedIndex = 3
    }

    private func tabItem(for tab: Tab) -> UITabBarItem {
        let item = UITabBarItem(
            title: tab.title,
            image: UIImage(systemName: tab.image),
            tag: tab.rawValue
        )
        return item
    }

    private func makeSettings() -> UIViewController {
        return SettingsViewController()
    }

    deinit {
        print("\(String(describing: self)) dealloc" )
    }
}

enum Tab: Int, CaseIterable {
    case chats
    case channels
    case users
    case settings

    var title: String {
        switch self {
        case .chats: return "Chats"
        case .channels: return "Channels"
        case .users: return "Users"
        case .settings: return "Settings"
        }
    }

    var image: String {
        switch self {
        case .chats: return "message"
        case .channels: return "quote.bubble"
        case .users: return "person.2"
        case .settings: return "gear"
        }
    }
}
