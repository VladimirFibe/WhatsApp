import Foundation

final class TabBarCoordinator: BaseCoordinator {
    enum Deeplink {
        case initial
    }

    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let transitionFactory: TransitionFactory
    private let tabBarManager: TabBarManagerProtocol
    private let output: AuthorizationModuleOutput & BaseCoordinator

    init(
        output: AuthorizationModuleOutput & BaseCoordinator,
        router: Routable,
        parent: BaseCoordinator,
        coordinatorFactory: CoordinatorFactoryProtocol,
        transitionFactory: TransitionFactory,
        tabBarManager: TabBarManagerProtocol
    ) {
        self.coordinatorFactory = coordinatorFactory
        self.transitionFactory = transitionFactory
        self.tabBarManager = tabBarManager
        self.output = output
        super.init(router: router, parent: parent)
    }
}

extension TabBarCoordinator: Coordinator {
    func start(with option: Deeplink) {
        tabBarManager.delegate = self
        prepareTabs()
    }
}

extension TabBarCoordinator: TabBarManagerDelegate {
    func repeatedTap(tab: Tab) {
        print(#function)
    }

    func didSelectTab(tab: Tab) {
        print(#function)
    }
}

// MARK: - Navigation

private extension TabBarCoordinator {
    func prepareTabs() {
        tabBarManager.setPresentable([
            makeTabOne(),
            makeTabTwo(),
            makeTabThree(),
            makeTabFour(),
        ])
        router.setRootModule(tabBarManager.tabBarPresentable, transition: transitionFactory.custom)
    }

    func makeTabOne() -> Presentable {
        let unit = coordinatorFactory.makePrototypeTabCoordinator(parent: self, tab: .chats)
        unit.coordinator.start(with: .initial)
        return unit.view
    }

    func makeTabTwo() -> Presentable {
        let unit = coordinatorFactory.makePrototypeTabCoordinator(parent: self, tab: .channels)
        unit.coordinator.start(with: .initial)
        return unit.view
    }

    func makeTabThree() -> Presentable {
        let unit = coordinatorFactory.makePrototypeTabCoordinator(parent: self, tab: .users)
        unit.coordinator.start(with: .initial)
        return unit.view
    }

    func makeTabFour() -> Presentable {
        let unit = coordinatorFactory.makeSettingsTabCoordinator(
            output: output,
            parent: self,
            tab: .settings
        )
        unit.coordinator.start(with: .initial)
        return unit.view
    }
}
