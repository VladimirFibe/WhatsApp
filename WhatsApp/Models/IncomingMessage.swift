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
        print(message.text)
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
                    let videoURL = URL(fileURLWithPath: fileInDocumetsDirectory(fileName: filename))
                    let videoItem = VideoMessage(url: videoURL)
                    mkMessage.videoItem = videoItem
                    mkMessage.kind = MessageKind.video(videoItem)
                    self.controller.messagesCollectionView.reloadData()
                }

            }
//            FileStorage.downloadImage(id: message.id, link: message.pictureUrl) { thumbNail in
//
//            }
        }
        return mkMessage
    }
/*
    if localMessage.type == kVIDEO {

        FileStorage.downloadImage(imageUrl: localMessage.pictureUrl) { (thumbNail) in

            FileStorage.downloadVideo(videoLink: localMessage.videoUrl) { (readyToPlay, fileName) in

                let videoURL = URL(fileURLWithPath: fileInDocumentsDirectory(fileName: fileName))

                let videoItem = VideoMessage(url: videoURL)

                mkMessage.videoItem = videoItem
                mkMessage.kind = MessageKind.video(videoItem)
            }

            mkMessage.videoItem?.image = thumbNail
            self.messageCollectionView.messagesCollectionView.reloadData()
        }
    }
 */
}

