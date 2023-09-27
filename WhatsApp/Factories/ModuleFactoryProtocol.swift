import Foundation

protocol ModuleFactoryProtocol: AnyObject {
    func makeAuthModule(output: AuthorizationModuleOutput) -> Presentable
    func makeTabModule(
        pushUnitHandler: @escaping () -> Void,
        pushModuleHandler: @escaping () -> Void,
        modalModuleHandler: @escaping () -> Void,
        modalUnitHandler: @escaping () -> Void
    ) -> Presentable
    func makeSettingsTabModule(
        output: AuthorizationModuleOutput,
        pushUnitHandler: @escaping () -> Void,
        pushModuleHandler: @escaping () -> Void,
        modalModuleHandler: @escaping () -> Void,
        modalUnitHandler: @escaping () -> Void
    ) -> Presentable
    func makeEditProfileModule(profileStatusHandler: @escaping Callback) -> Presentable
    func makeProfileStatusModule() -> Presentable
}
