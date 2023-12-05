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
            let photoItem = PhotoMessage(path: message.pictureUrl)
            mkMessage.photoItem = photoItem
            mkMessage.kind = MessageKind.photo(photoItem)
            FileStorage.downloadImage(id: message.text, link: message.pictureUrl) { image in
                mkMessage.photoItem?.image = image
                self.controller.messagesCollectionView.reloadData()
            }
        }
        return mkMessage
    }
}

