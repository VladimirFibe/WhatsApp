import MessageKit
import Foundation

extension ChatViewController: MessagesLayoutDelegate {
    // MARK: = Cell top label
    
    func cellTopLabelHeight(
        for message: any MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> CGFloat {
        indexPath.section % 3 == 0 ? 18 : 0
    }
    
    func cellBottomLabelHeight(
        for message: any MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> CGFloat {
        isFromCurrentSender(message: message) ? 17 : 0
    }
    
    func messageBottomLabelHeight(
        for message: any MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> CGFloat {
        indexPath.section == mkMessages.count - 1 ? 10 : 0
    }
    
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: any MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) {
        <#code#>
    }
}
