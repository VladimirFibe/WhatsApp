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
        if Auth.auth().currentUser == nil {
            window?.rootViewController = AuthViewController()
        } else {
            window?.rootViewController = MainTabBarViewController()
        }
        window?.makeKeyAndVisible()
        return true
    }
}

