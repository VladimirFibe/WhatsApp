
import UIKit

open class SystemNavigationController: UINavigationController, UIGestureRecognizerDelegate, SystemNavigation {
	public var popToRootHandler: (() -> Void)?
	public var popHandler: (() -> Void)?

	private let hideNavigationBar: Bool

	override open func popToRootViewController(animated: Bool) -> [UIViewController]? {
		defer {
			popToRootHandler?()
		}
		return super.popToRootViewController(animated: animated)
	}

	open override func popViewController(animated: Bool) -> UIViewController? {
		defer {
			popHandler?()
		}
		return super.popViewController(animated: animated)
	}

	public init(hideNavigationBar: Bool) {
		self.hideNavigationBar = hideNavigationBar
		super.init(nibName: nil, bundle: nil)
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override open func viewDidLoad() {
		super.viewDidLoad()
		navigationBar.isHidden = hideNavigationBar
		interactivePopGestureRecognizer?.isEnabled = true
		interactivePopGestureRecognizer?.delegate = self


		if #available(iOS 15.0, *) {
			let appearance = UINavigationBarAppearance()
			let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
			appearance.configureWithDefaultBackground()
			appearance.backgroundColor = .systemBackground
			appearance.titleTextAttributes = [.foregroundColor: UIColor.black]

			buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
			UINavigationBar.appearance().tintColor = UIColor.black
			appearance.buttonAppearance = buttonAppearance

			navigationBar.standardAppearance = appearance
			navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
		}
	}

	public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		guard gestureRecognizer == interactivePopGestureRecognizer else {
			return true
		}

		return viewControllers.count > 1 && presentedViewController == nil
	}	
}
