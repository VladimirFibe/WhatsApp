import Foundation



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

    func makeSettingsTabModule(
        output: AuthorizationModuleOutput,
        pushUnitHandler: @escaping () -> Void,
        pushModuleHandler: @escaping () -> Void,
        modalModuleHandler: @escaping () -> Void,
        modalUnitHandler: @escaping () -> Void
    ) -> Presentable {
        return SettingsModuleViewController(
            output: output,
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

    func makeEditProfileModule(profileStatusHandler: @escaping Callback) -> Presentable {
        return EditProfileViewController(
            model: .init(closeUnitHandler: nil, profileStatusHandler: profileStatusHandler))
    }


    func makeProfileStatusModule() -> Presentable {
        return ProfileStatusViewController()
    }
}
