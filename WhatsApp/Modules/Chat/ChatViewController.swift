import UIKit
import MessageKit
import InputBarAccessoryView

final class ChatViewController: MessagesViewController {

    private let refreshControl = UIRefreshControl()

    private let micButton = InputBarButtonItem()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
// MARK: - Configurations
extension ChatViewController {
    private func confugureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self

        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnInputBarHeightChanged = true

        messagesCollectionView.refreshControl = refreshControl
    }

    private func configureMesssageInputBar() {
        messageInputBar.delegate = self

        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "plus")
        attachButton.onTouchUpInside { item in
            print("Attach button pressed")
        }
        micButton.image = UIImage(systemName: "mic.fill")
        micButton.onTouchUpInside { item in
            print("Mic button pressed")
        }

        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: true)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {

}

extension ChatViewController: MessagesDataSource {

}

extension ChatViewController: MessageCellDelegate {

}

extension ChatViewController: MessagesDisplayDelegate {

}

extension ChatViewController: MessagesLayoutDelegate {

}
