import Foundation
import UIKit
import FirebaseFirestoreSwift

class OutgoingMessage {
    static func save(message: Message, recent: Recent) {
        RealmManager.shared.saveToRealm(message)
        FirebaseClient.shared.sendMessage(message, recent: recent)
    }

    static func send(
        recent: Recent,
        text: String?,
        photo: UIImage?,
        videoUrl: URL?,
        audio: String?,
        audioDuration: Float = 0.0,
        location: String?,
        memberIds: [String]
    ) {

        guard let currentUser = FirebaseClient.shared.person else { return }

        let message = Message()
        message.id = UUID().uuidString
        message.chatRoomId = Person.chatRoomIdFrom(id: recent.chatRoomId)
        message.uid = Person.currentId
        message.name = currentUser.username
        message.initials = String(currentUser.username.first ?? "?")
        message.date = Date()
        message.status = kSENT
        if let text {
            message.text = text
            message.type = kTEXT
            save(message: message, recent: recent)
        } else if let photo {
            message.text = "Photo Message"
            message.type = kPHOTO
            let fileDirectory = "MediaMessages/Photo/\(message.chatRoomId)/\(message.id).jpg"
            guard let data = photo.jpegData(compressionQuality: 0.6) as? NSData else {return}
            FileStorage.saveFileLocally(fileData: data, fileName: "\(message.id).jpg")
            FileStorage.uploadImage(photo, directory: fileDirectory) { pictureUrl in
                if let pictureUrl {
                    message.pictureUrl = pictureUrl
                    save(message: message, recent: recent)
                }
            }
        } else if let videoUrl {
            message.text = "Video Message"
            message.type = kVIDEO
            guard let nsData = NSData(contentsOfFile: videoUrl.path) else { return }
            let videoDirectory = "MediaMessages/Video/\(message.chatRoomId)/\(message.id).mov"
            FileStorage.saveFileLocally(fileData: nsData, fileName: "\(message.id).mov")
            FileStorage.uploadData(nsData as Data, directory: videoDirectory) { videoUrl in
                if let videoUrl {
                    message.videoUrl = videoUrl
                    save(message: message, recent: recent)
                }
            }
        }
        // TODO: Send push notifition
        // TODO: update recent

    }

}
