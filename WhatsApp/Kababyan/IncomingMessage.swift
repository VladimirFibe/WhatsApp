import Foundation
import MessageKit
import CoreLocation

class IncomingMessage {
    
    var messageCollectionView: MessagesViewController
    
    init(_ collectionView: MessagesViewController) {
        messageCollectionView = collectionView
    }
        
    //MARK: - CreateMessage
    
    func createMessage(localMessage: LocalMessage) -> MKMessage? {
        
        let mkMessage = MKMessage(message: localMessage)
        return mkMessage
    }
}

