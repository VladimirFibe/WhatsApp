import UIKit

protocol TabFactoryProtocol {
    func makeBarItem(for tab: Tab) -> UITabBarItem
}

final class TabFactory: TabFactoryProtocol {
    func makeBarItem(for tab: Tab) -> UITabBarItem {
        UITabBarItem(title: tab.title, image: UIImage(systemName: tab.image), tag: tab.rawValue)
    }
}
