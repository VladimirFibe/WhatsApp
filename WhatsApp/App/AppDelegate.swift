import UIKit
import FirebaseCore
import FirebaseAuth
import SwiftUI
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AnyCoordinator<Void>?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = SystemNavigationController(hideNavigationBar: true)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        let router = ApplicationRouter(rootController: rootViewController)
        let appCoordinator = CoordinatorFactory.shared.makeApplicationCoordinator(router: router)
        appCoordinator.start()
        self.appCoordinator = appCoordinator
        FirebaseApp.configure()
        if Auth.auth().currentUser != nil {
            signOut()
        }
        return true
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error while trying to sign out: \(error.localizedDescription)")
        }
    }
}

