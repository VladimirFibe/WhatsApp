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
        let callback: Callback = { [weak self] in
            self?.setRootViewController()
        }
        if Auth.auth().currentUser == nil {
            let authUseCase = AuthUseCase(apiService: FirebaseClient.shared)
            let store = AuthStore(authUseCase: authUseCase)
            window?.rootViewController = AuthViewController(store: store, callback: callback)
        } else {
            window?.rootViewController = MainTabBarViewController(callback: callback)
        }
        window?.makeKeyAndVisible()
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

