import UIKit
import SwiftUI

final class MainTabBarViewController: UITabBarController {
    var callback: Callback?
    init(callback: Callback? = nil) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        fetchPerson()
    }

    private func fetchPerson() {
        Task {
            do {
                try await FirebaseClient.shared.fetchPerson()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func setupTabBar() {
        view.backgroundColor = .systemBackground
        let chats = UINavigationController(rootViewController: ChatsTableViewController())
        let channels = UINavigationController(rootViewController: ChannelsViewController())
        let users = UINavigationController(rootViewController: UsersViewControlller())
        let settings = UINavigationController(rootViewController: SettingsViewController(callback: callback))
        chats.tabBarItem = tabItem(for: .chats)
        channels.tabBarItem = tabItem(for: .channels)
        users.tabBarItem = tabItem(for: .users)
        settings.tabBarItem = tabItem(for: .settings)
        setViewControllers([chats, channels, users, settings], animated: true)
        selectedIndex = 0
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
