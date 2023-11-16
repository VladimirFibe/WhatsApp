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
            window?.rootViewController = AuthViewController(callback: callback)
        } else {
            window?.rootViewController = MainTabBarViewController(callback: callback)
        }
        window?.makeKeyAndVisible()
    }
}

