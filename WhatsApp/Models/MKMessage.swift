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
    var videoItem: VideoMessage?
    var locationItem: LocationMessage?
    var audioItem: AudioMessage?

    init(message: Message) {
        self.messageId = message.id
        self.mkSender = MKSender(senderId: message.uid, displayName: message.name)
        self.status = message.status
        self.senderInitials = message.initials
        self.sentDate = message.date
        self.readDate = message.readDate
        self.incoming = Person.currentId != message.uid
        switch message.type {
        case kAUDIO:
            let audioItem = AudioMessage(duration: 2)
            self.kind = MessageKind.audio(audioItem)
            self.audioItem = audioItem
        case kLOCATION:
            let locationItem = LocationMessage(location: CLLocation(
                latitude: message.latitude,
                longitude: message.longitude
            ))
            self.kind = MessageKind.location(locationItem)
            self.locationItem = locationItem
        case kVIDEO:
            let videoItem = VideoMessage(url: nil)
            self.kind = MessageKind.video(videoItem)
            self.videoItem = videoItem
        case kPHOTO:
            let url = URL(fileURLWithPath: message.pictureUrl)
            let photoItem = PhotoMessage(url: url)
            self.kind = MessageKind.photo(photoItem)
            self.photoItem = photoItem
        default:
            self.kind = MessageKind.text(message.text)
        }
    }
}
