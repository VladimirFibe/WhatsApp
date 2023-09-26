import Foundation

protocol CoordinatorFactoryProtocol: AnyObject {
    func makeApplicationCoordinator(router: Routable) -> AnyCoordinator<Void>
    func makeAuthCoordinator(output: AuthorizationModuleOutput & BaseCoordinator, router: Routable) -> AnyCoordinator<Void>
    func makeTabBarCoordinator(router: Routable, parent: BaseCoordinator) -> AnyCoordinator<TabBarCoordinator.Deeplink>
    func makePrototypeTabCoordinator(parent: BaseCoordinator, tab: Tab)
    -> (view: Presentable, coordinator: AnyCoordinator<PrototypeTabCoordinator.Deeplink>)
}

final class CoordinatorFactory: CoordinatorFactoryProtocol {
    static let shared = CoordinatorFactory()
    let tabFactory = TabFactory()
    private init() {}
    
    func makeApplicationCoordinator(router: Routable) -> AnyCoordinator<Void> {
        AnyCoordinator(ApplicationCoordinator(
            router: router,
            coordinatorFactory: self
        ))
    }
    
    func makeAuthCoordinator(output: AuthorizationModuleOutput & BaseCoordinator, router: Routable) -> AnyCoordinator<Void> {
        let coordinator = AnyCoordinator(AuthCoordinator(
            output: output,
            router: router,
            parent: output,
            moduleFactory: ModuleFactory.shared,
            coordinatorFactory: self
        ))
        return coordinator
    }

    func makeTabBarCoordinator(router: Routable, parent: BaseCoordinator) -> AnyCoordinator<TabBarCoordinator.Deeplink> {
        let tabbarController = SystemTabBarController()
        let tabbarManager = TabBarManager(tabBar: tabbarController)
        return AnyCoordinator(
            TabBarCoordinator(
                router: router,
                parent: parent,
                coordinatorFactory: self,
                transitionFactory: TransitionFactory.shared,
                tabBarManager: tabbarManager
            )
        )
    }

    func makePrototypeTabCoordinator(parent: BaseCoordinator, tab: Tab)
    -> (view: Presentable, coordinator: AnyCoordinator<PrototypeTabCoordinator.Deeplink>) {
        let navigation = SystemNavigationController(hideNavigationBar: false)
        navigation.tabBarItem = tabFactory.makeBarItem(for: tab)
        let router = ApplicationRouter(rootController: navigation)
        let coordinator = AnyCoordinator(
            PrototypeTabCoordinator(
                router: router,
                parent: parent,
                coordinatorFactory: self,
                moduleFactory: ModuleFactory.shared
            )
        )
        return (navigation, coordinator)
    }
}


