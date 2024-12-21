import UIKit
import MessageKit

extension ChatViewController: MessagesDataSource {
    var currentSender: any MessageKit.SenderType {
        currentUser
    }
    
    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessageKit.MessagesCollectionView
    ) -> any MessageKit.MessageType {
        mkMessages[indexPath.section]
    }
    
    func numberOfSections(
        in messagesCollectionView: MessageKit.MessagesCollectionView
    ) -> Int {
        mkMessages.count
    }
    
    // MARK: - Cell top labels
    
    func cellTopLabelAttributedText(
        for message: any MessageType,
        at indexPath: IndexPath
    ) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            let showLoadMore = false
            let text = showLoadMore ? "Pull to load more ... " : MessageKitDateFormatter.shared.string(from: message.sentDate)
            let font = showLoadMore ? UIFont.systemFont(ofSize: 13) : UIFont.boldSystemFont(ofSize: 10)
            let color = showLoadMore ? UIColor.systemBlue : UIColor.darkGray
            return NSAttributedString(
                string: text,
                attributes: [.font: font, .foregroundColor: color]
            )
        } else {
            return nil
        }
    }
    
    func cellBottomLabelAttributedText(
        for message: any MessageType,
        at indexPath: IndexPath
    ) -> NSAttributedString? {
        if isFromCurrentSender(message: message) {
            let mkMessage = mkMessages[indexPath.section]
            let status = indexPath.section == mkMessages.count - 1 ? "\(mkMessage.status) \(mkMessage.readDate.time)" : ""
            return NSAttributedString(
                string: status,
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 10),
                    .foregroundColor: UIColor.darkGray
                ]
            )
        } else {
            return nil
        }
    }
}
