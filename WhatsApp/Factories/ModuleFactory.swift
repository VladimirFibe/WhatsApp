import Foundation

protocol ModuleFactoryProtocol: AnyObject {
    func makeAuthModule(output: AuthorizationModuleOutput) -> Presentable
    func makeTabModule(
        pushUnitHandler: @escaping () -> Void,
        pushModuleHandler: @escaping () -> Void,
        modalModuleHandler: @escaping () -> Void,
        modalUnitHandler: @escaping () -> Void
    ) -> Presentable
}

final class ModuleFactory: ModuleFactoryProtocol {
    static let shared = ModuleFactory()
    private init() {}

    func makeAuthModule(output: AuthorizationModuleOutput) -> Presentable {
        let useCase = AuthUseCase(apiService: FirebaseClient.shared)
        let store = AuthStore(authUseCase: useCase)
        return AuthorizationViewController(
            store: store,
            output: output
        )
    }

    func makeTabModule(
        pushUnitHandler: @escaping () -> Void,
        pushModuleHandler: @escaping () -> Void,
        modalModuleHandler: @escaping () -> Void,
        modalUnitHandler: @escaping () -> Void
    ) -> Presentable {
        return PrototypeModuleViewController(
            model: .init(
                pushUnitHandler: pushUnitHandler,
                pushModuleHandler: pushModuleHandler,
                closeUnitOrModuleHandler: nil,
                popToRootHandler: nil,
                modalModuleHandler: modalModuleHandler,
                modalUnitHandler: modalUnitHandler,
                closeModalHandler: nil
            )
        )
    }
}
