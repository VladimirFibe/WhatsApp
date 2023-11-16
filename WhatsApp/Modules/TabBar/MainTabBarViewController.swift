import UIKit

final class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        view.backgroundColor = .systemBackground
        let chats = UINavigationController(rootViewController: ProfileViewController())
        let channels = UINavigationController(rootViewController: ProfileViewController())
        let users = UINavigationController(rootViewController: ProfileViewController())
        let settings = UINavigationController(rootViewController: SettingsViewController())
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
}
