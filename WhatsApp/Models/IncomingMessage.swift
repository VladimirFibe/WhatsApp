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
        MKMessage(message: message)
    }
}

