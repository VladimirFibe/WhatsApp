import Foundation

protocol CoordinatorFactoryProtocol: AnyObject {
    func makeApplicationCoordinator(router: Routable) -> AnyCoordinator<Void>
    func makeAuthCoordinator(parent: BaseCoordinator, router: Routable) -> AnyCoordinator<Void>
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
    
    func makeAuthCoordinator(parent: BaseCoordinator, router: Routable) -> AnyCoordinator<Void> {
        let coordinator = AnyCoordinator(AuthCoordinator(
            output: self,
            router: router,
            parent: parent,
            moduleFactory: ModuleFactory.shared,
            coordinatorFactory: self
        ))
        return coordinator
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

extension CoordinatorFactory: AuthorizationModuleOutput {
    func moduleFinish() {
        print("Вошли")
    }
}

