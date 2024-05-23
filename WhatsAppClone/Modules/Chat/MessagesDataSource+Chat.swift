import MessageKit
import UIKit
extension ChatViewController: MessagesDataSource {
    var currentSender: any MessageKit.SenderType {
        currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        mkMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        mkMessages.count
    }

    //MARK: - Cell top labels

    func cellTopLabelAttributedText(for message: any MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            let text = MessageKitDateFormatter.shared.string(from: message.sentDate)
            let font = UIFont.systemFont(ofSize: 10)
            let color = UIColor.darkGray
            return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
        } else {
            return nil
        }
    }

    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isFromCurrentSender(message: message) {
            let message = mkMessages[indexPath.section]
            let status = indexPath.section == (mkMessages.count - 1) ? "\(message.status) \(message.readDate.time)" : ""
            return NSAttributedString(string: status,
                                      attributes: [
                                        .font: UIFont.systemFont(ofSize: 10),
                                        .foregroundColor: UIColor.darkGray
                                      ])
        } else {
            return nil
        }
    }

    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section == mkMessages.count - 1 {
            return nil
        } else {
            return NSAttributedString(string: message.sentDate.time, 
                                      attributes: [
                                        .font: UIFont.systemFont(ofSize: 10),
                                        .foregroundColor: UIColor.darkGray
                                      ])
        }
    }
}

struct MKSender: SenderType, Equatable {
    var senderId: String
    var displayName: String
}

enum MessageDefaults {
    static let bubbleColorOutgoing = UIColor.chatOutgoingBubble
    static let bubbleColorIncoming = UIColor.chatIncomingBubble
}
