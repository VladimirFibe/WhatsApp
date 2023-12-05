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
    var photoItem: PhotoMessage?

    init(message: Message) {
        self.messageId = message.id
        self.mkSender = MKSender(senderId: message.uid, displayName: message.name)
        self.status = message.status
        self.senderInitials = message.initials
        self.sentDate = message.date
        self.readDate = message.readDate
        self.incoming = Person.currentId != message.uid
        switch message.type {
        case kPHOTO:
            let photoItem = PhotoMessage(path: message.pictureUrl)
            self.kind = MessageKind.photo(photoItem)
            self.photoItem = photoItem
        default:
            self.kind = MessageKind.text(message.text)
        }
    }
}
