import Foundation
import UIKit
import FirebaseFirestoreSwift

class OutgoingMessage {
    
    static func send(
        recent: Recent,
        text: String?,
        photo: UIImage?,
        video: String?,
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
            RealmManager.shared.saveToRealm(message)
        }
        FirebaseClient.shared.sendMessage(message, recent: recent)
        // TODO: Send push notifition
        // TODO: update recent
    }

}
