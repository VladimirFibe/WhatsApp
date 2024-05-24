import Foundation
import MessageKit
import CoreLocation

class MKMessage: NSObject, MessageType {

    var messageId: String
    var kind: MessageKind
    var sentDate: Date
    var incoming: Bool
    var mkSender: MKSender
    var sender: SenderType { mkSender }
    var senderInitials: String
    var status: String
    var readDate: Date

    init(message: Message) {
        self.messageId = message.id
        self.mkSender = MKSender(senderId: message.uid, displayName: message.name)
        self.status = message.status
        self.senderInitials = message.initials
        self.sentDate = message.date
        self.readDate = message.readDate
        self.incoming = message.incoming
        self.kind = MessageKind.text(message.text)
        print("init", message.incoming)
    }
}
