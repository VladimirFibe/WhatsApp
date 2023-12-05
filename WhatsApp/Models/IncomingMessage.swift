import Foundation
import MessageKit
import CoreLocation

class IncomingMessage {
    
    var messageCollectionView: MessagesViewController
    
    init(_ collectionView: MessagesViewController) {
        messageCollectionView = collectionView
    }
        
    //MARK: - CreateMessage
    
    func createMessage(_ message: Message) -> MKMessage? {
        let mkMessage = MKMessage(message: message)
        print(message.text)
        if message.type == kPHOTO {
            print("DEBUG: Photo")
        }
        return mkMessage
    }
}

