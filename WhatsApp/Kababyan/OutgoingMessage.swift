import Foundation
import UIKit
import FirebaseFirestoreSwift

class OutgoingMessage {
    
    static func send(
        recent: Recent,
        chatId: String,
        text: String?,
        photo: UIImage?,
        video: String?,
        audio: String?,
        audioDuration: Float = 0.0,
        location: String?,
        memberIds: [String]
    ) {

        guard let currentUser = FirebaseClient.shared.person else { return }

        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser.id ?? ""
        message.senderName = currentUser.username
        message.senderInitials = String(currentUser.username.first ?? "?")
        message.date = Date()
        message.status = kSENT
        if let text {
            message.message = text
            message.type = kTEXT
            sendMessage(message: message, memberIds: memberIds)
        }
        guard let friendUid = memberIds.last else { return }
        do {
            try FirebaseClient.shared.sendMessage(message, recent: recent)
        } catch {
            print(error.localizedDescription)
        }
        // TODO: Send push notifition
        // TODO: update recent
    }

    static func sendMessage(message: LocalMessage, memberIds: [String]) {
        RealmManager.shared.saveToRealm(message)
        for memberId in memberIds {
            print(memberId)
        }
    }
}
