import Foundation
import MessageKit
import CoreLocation

class IncomingMessage {
    
    var controller: MessagesViewController

    init(_ controller: MessagesViewController) {
        self.controller = controller
    }
        
    //MARK: - CreateMessage
    
    func createMessage(_ message: Message) -> MKMessage? {
        let mkMessage = MKMessage(message: message)
        if message.type == kPHOTO {
            let url = URL(fileURLWithPath: message.pictureUrl)
            let photoItem = PhotoMessage(url: url)
            mkMessage.photoItem = photoItem
            mkMessage.kind = MessageKind.photo(photoItem)
            FileStorage.downloadImage(id: message.id, link: message.pictureUrl) { image in
                mkMessage.photoItem?.image = image
                self.controller.messagesCollectionView.reloadData()
            }
        }
        if message.type == kVIDEO {
            FileStorage.downloadVideo(id: message.id, link: message.videoUrl) { filename in
                if let filename {
                    let videoURL = URL(fileURLWithPath: FileStorage.fileInDocumetsDirectory(fileName: filename))
                    let videoItem = VideoMessage(url: videoURL)
                    mkMessage.videoItem = videoItem
                    mkMessage.kind = MessageKind.video(videoItem)
                    self.controller.messagesCollectionView.reloadData()
                }
            }
        }
        if message.type == kLOCATION {
            let locationItem = LocationMessage(location: CLLocation(
                latitude: message.latitude,
                longitude: message.longitude
            ))
            mkMessage.kind = MessageKind.location(locationItem)
            mkMessage.locationItem = locationItem
            self.controller.messagesCollectionView.reloadData()
        }
        if message.type == kAUDIO {
            FileStorage.downloadAudio(id: message.id, link: message.audioUrl) { filename in
                if let filename {
                    let audioItem = AudioMessage(duration: message.audioDuration)
                    mkMessage.audioItem = audioItem
                    mkMessage.kind = MessageKind.audio(audioItem)
                    let url = URL(fileURLWithPath: FileStorage.fileInDocumetsDirectory(fileName: filename))
                    mkMessage.audioItem?.url = url
                    mkMessage.audioItem?.duration = Float(message.audioDuration)
                    self.controller.messagesCollectionView.reloadData()
                }
            }
        }
        return mkMessage
    }
}

