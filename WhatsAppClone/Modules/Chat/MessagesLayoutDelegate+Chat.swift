import MessageKit
import Foundation

extension ChatViewController: MessagesLayoutDelegate {
    func cellTopLabelHeight(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0 {
            return 18
        } else {
            return 0
        }
    }

    func cellBottomLabelHeight(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        isFromCurrentSender(message: message) ? 17 : 0
    }

    func messageBottomLabelHeight(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        indexPath.section != mkMessages.count - 1 ? 10 : 0
    }

    func configureAvatarView(_ avatarView: AvatarView, for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let initials = mkMessages[indexPath.section].senderInitials
        avatarView.set(avatar: Avatar(image: .avatar))
    }
}
