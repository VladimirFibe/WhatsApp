import UIKit
import MessageKit

extension ChatViewController: MessagesDataSource {
    var currentSender: MessageKit.SenderType {
        currentUser
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        mkMessages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        mkMessages.count
    }

    //MARK: - Cell top labels

    func cellTopLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath
    ) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            let showLoadMore = (indexPath.section == 0) && (allLocalMessages.count > displayingMessagesCount)
            let text = showLoadMore ? "Pull to load more" 
            : MessageKitDateFormatter.shared.string(from: message.sentDate)
            let font = showLoadMore ? UIFont.systemFont(ofSize: 13) 
            : UIFont.systemFont(ofSize: 10)
            let color = showLoadMore ? UIColor.systemBlue : UIColor.darkGray
            return NSAttributedString(string: text,
                                      attributes: [.font: font, .foregroundColor: color]
            )
        }
        return nil
    }

    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isFromCurrentSender(message: message) {
            let message = mkMessages[indexPath.section]
            let status = indexPath.section == (mkMessages.count - 1) ? message.status + " " + message.readDate.time() : ""
            return NSAttributedString(string: status, attributes: [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.darkGray
            ])
        }
        return nil
    }

    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section == mkMessages.count - 1 {
            return nil
        }

        return NSAttributedString(string: message.sentDate.time(), attributes: [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.darkGray
        ])
    }
}
