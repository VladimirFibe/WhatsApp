import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        setRootViewController()
        return true
    }

    func setRootViewController() {
        if Auth.auth().currentUser == nil {
            window?.rootViewController = makeAuth()
        } else {
            FirebaseClient.shared.firstFetchPerson()
            window?.rootViewController = makeTabbar()
        }
        window?.makeKeyAndVisible()
    }

    private func makeTabbar() -> UIViewController {
        let callback: Callback = { [weak self] in
            self?.setRootViewController()
        }
        return MainTabBarViewController(callback: callback)
    }

    private func makeAuth() -> UIViewController {
        let useCase = AuthUseCase(apiService: FirebaseClient.shared)
        let store = AuthStore(useCase: useCase)
        let callback: Callback = { [weak self] in
            self?.setRootViewController()
        }
        let controller = AuthViewController(store: store, callback: callback)
        return UINavigationController(rootViewController: controller)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        LocationManager.shared.startUpdating()
    }
    func applicationWillResignActive(_ application: UIApplication) {
        LocationManager.shared.stopUpdating()
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        LocationManager.shared.stopUpdating()
    }
}

