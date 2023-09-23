import SwiftUI

typealias BridgedView = UIViewController

extension View {
    public func bridge() -> UIHostingController<Self> {
        RestrictedUIHostingController(rootView: self).apply { vc in
            vc.view.backgroundColor = .clear
        }
    }

    public func bridgeAndApply(_ configurator: (UIView) -> Void) -> UIHostingController<Self> {
        bridge().apply { vc in
            configurator(vc.view)
        }
    }
}

