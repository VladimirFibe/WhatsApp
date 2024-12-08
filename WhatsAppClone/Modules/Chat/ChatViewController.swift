import UIKit
import MessageKit
import Realm

final class ChatViewController: MessagesViewController {
    public let recent: Recent
    init(recent: Recent) {
        self.recent = recent
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
