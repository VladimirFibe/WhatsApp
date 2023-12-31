import Foundation
import UIKit
import Firebase
import FirebaseFirestoreSwift

class OutgoingMessage {
    static func save(message: Message, recent: Recent?) {
        print(message.id, message.text)
        RealmManager.shared.saveToRealm(message)
        if let recent {
            FirebaseClient.shared.sendMessage(message, recent: recent)
        } else {
            FirebaseClient.shared.sendMessage(message)
        }
    }

    static func send(
        chatRoomId: String,
        recent: Recent?,
        text: String?,
        photo: UIImage?,
        videoUrl: URL?,
        audio: String?,
        audioDuration: Float = 0.0,
        location: String?,
        memberIds: [String]
    ) {
        guard let currentUser = FirebaseClient.shared.person else {
            print("DEBUG: currenUser", Auth.auth().currentUser?.uid ?? "nil")
            return
        }
        let message = Message()
        message.id = UUID().uuidString
        message.chatRoomId = chatRoomId
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
        } else if location != nil {
            guard let currentLocation = LocationManager.shared.currentLocation else { return }
            message.text = "Location message"
            message.type = kLOCATION
            message.latitude = currentLocation.latitude
            message.longitude = currentLocation.longitude
            save(message: message, recent: recent)
        } else if let audio {
            message.text = "Audio message"
            message.type = kAUDIO
            message.audioDuration = Double(audioDuration)
            guard let data = NSData(contentsOfFile: getDocumentsURL().appendingPathComponent("\(audio).m4a").path) as? Data 
            else { return }
            let audioDirectory = "MediaMessages/Audio/\(message.chatRoomId)/\(message.id).m4a"
            FileStorage.uploadData(data, directory: audioDirectory) { audioUrl in
                if let audioUrl {
                    message.audioUrl = audioUrl
                    save(message: message, recent: recent)
                }
            }
        }
        // TODO: Send push notifition
        // TODO: update recent

    }

}
