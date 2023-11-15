import UIKit

protocol AppFontProtocol {
    var rawValue: String { get }
}

extension AppFontProtocol {
    func s16() -> UIFont { apply(size: 16) }
    func s20() -> UIFont { apply(size: 20) }
    func s35() -> UIFont { apply(size: 35) }
}

extension AppFontProtocol {
    private func apply(size value: CGFloat) -> UIFont {
        UIFont.init(name: rawValue, size: value) ?? .systemFont(ofSize: value)
    }
}

enum AppFont: String, AppFontProtocol {
    case book = "Avenir-Book"
    case roman = "Avenir-Roman"
    case light = "Avenir-Light"
    case medium = "Avenir-Medium"
    case black = "Avenir-Black"
}
