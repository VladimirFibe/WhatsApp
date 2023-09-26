import Foundation

enum Tab: Int, CaseIterable {
    case chats
    case channels
    case users
    case settings

    var title: String {
        switch self {
        case .chats: return "Chats"
        case .channels: return "Channels"
        case .users: return "Users"
        case .settings: return "Settings"
        }
    }

    var image: String {
        switch self {
        case .chats: return "message"
        case .channels: return "quote.bubble"
        case .users: return "person.2"
        case .settings: return "gear"
        }
    }
}
