import Foundation
import MessageKit

extension ChatViewController: MessagesLayoutDelegate {
    //MARK: Cell top label
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0 {
            return 18
        }
        return 0
    }
}
