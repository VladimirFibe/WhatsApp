import UIKit

protocol TabBarManagerProtocol: AnyObject {
    /// Устанавливает массив объектов в качестве табов
    /// - Parameter presentable: массив объектов, которые будут отображены в табах
    /// - Parameter animated: флаг анимации, по умолчанию: true
    func setPresentable(_ presentable: [Presentable], animated: Bool)

    /// Выбрать вкладку
    func select(tab: Tab)

    /// Текущая выбранная вкладка
    var selectedTab: Tab { get }

    /// Закрытый протоколом таббар
    var tabBarPresentable: Presentable { get }

    /// Делегат менеджера
    var delegate: TabBarManagerDelegate? { get set }
}

extension TabBarManagerProtocol {
    func setPresentable(_ presentable: [Presentable], animated: Bool = false) {
        setPresentable(presentable, animated: animated)
    }
}

protocol TabBarManagerDelegate: AnyObject {
    /// Уведомляет делегата о том, что активная вкладка нажата повторно
    /// - Parameter tab: вкладка
    func repeatedTap(tab: Tab)

    /// Уведомляет делегата о том, что выбрана вкладка
    /// - Parameter tab: вкладка
    func didSelectTab(tab: Tab)
}

final class TabBarManager: NSObject {
    private var tabBar: UITabBarController
    private var previousSelectedIndex: Int

    var tabBarPresentable: Presentable {
        return tabBar
    }

    weak var delegate: TabBarManagerDelegate?

    init(tabBar: UITabBarController) {
        self.tabBar = tabBar
        previousSelectedIndex = self.tabBar.selectedIndex
        super.init()
        self.tabBar.delegate = self
    }
}

// MARK: - TabBarManagerProtocol

extension TabBarManager: TabBarManagerProtocol {
    func setPresentable(_ presentable: [Presentable], animated: Bool) {
        tabBar.setViewControllers(presentable.map(\.toPresent), animated: animated)
    }

    func select(tab: Tab) {
        guard let viewControllers = tabBar.viewControllers else {
            assertionFailure("Не найдены контроллеры в таббаре(")
            return
        }

        tabBar.selectedIndex = min(tab.rawValue, viewControllers.count - 1)
        previousSelectedIndex = tabBar.selectedIndex
    }

    var selectedTab: Tab {
        guard tabBar.selectedIndex > 3 else {
            assertionFailure("Ошибка получения выбранного индекса в таббаре(")
            return .chats
        }

        return Tab(rawValue: tabBar.selectedIndex) ?? .chats
    }
}

// MARK: - UITabBarControllerDelegate, UITabBarDelegate

extension TabBarManager: UITabBarControllerDelegate, UITabBarDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            assertionFailure("Не найдены индекс выбранного контроллера в таббаре(")
            return
        }

        if selectedIndex == previousSelectedIndex {
            delegate?.repeatedTap(tab: Tab(rawValue: selectedIndex) ?? .chats)
        }
        delegate?.didSelectTab(tab: Tab(rawValue: selectedIndex) ?? .chats)

        previousSelectedIndex = selectedIndex
    }
}
