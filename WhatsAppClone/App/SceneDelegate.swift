import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var authListener: AuthStateDidChangeListenerHandle?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        autoLogin()
    }
    
    private func autoLogin() {
        authListener = Auth.auth().addStateDidChangeListener{[weak self] auth, user in
            let result = user?.isEmailVerified ?? false
            self?.start(login: result)
        }
    }
    
    private func start(login: Bool) {
        if login {
            setRootViewController(makeTabbar())
        } else {
            setRootViewController(makeAuth())
        }
    }

    private func setRootViewController(_ controller: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
            return
        }

        window.rootViewController = controller
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }

    private func makeAuth() -> UIViewController {
        UINavigationController(rootViewController: AuthViewController())
    }

    private func makeTabbar() -> UIViewController {
        MainTabBarController()
    }
}

