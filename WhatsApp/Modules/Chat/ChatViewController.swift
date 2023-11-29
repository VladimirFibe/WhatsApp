import UIKit
import MessageKit
import InputBarAccessoryView

final class ChatViewController: MessagesViewController {
    private var chatId = "chatId"
    private var recipientId = "recipientId"
    private var recipientName = "recipientName"

    let currentUser = MKSender(senderId: Person.currentId, displayName: "Current User")
    private let refreshControl = UIRefreshControl()

    private let micButton = InputBarButtonItem()
    var mkMessages: [MKMessage] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        confugureMessageCollectionView()
        configureMesssageInputBar()
        navigationItem.title = recipientName
    }

    init(
        chatId: String = "chatId",
        recipientId: String = "recipientId",
        recipientName: String = "recipientName"
    ) {
        super.init(nibName: nil, bundle: nil)
        self.chatId = chatId
        self.recipientId = recipientId
        self.recipientName = recipientName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Configurations
extension ChatViewController {
    private func confugureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.refreshControl = refreshControl

        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnInputBarHeightChanged = true
    }

    private func configureMesssageInputBar() {
        messageInputBar.delegate = self

        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "plus")
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.onTouchUpInside { item in
            print("Attach button pressed")
        }
        micButton.image = UIImage(systemName: "mic.fill")
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)
        micButton.onTouchUpInside { item in
            print("Mic button pressed")
        }

        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
    }
}
// MARK: Actions
extension ChatViewController {
    func messageSend(
        text: String? = nil,
        photo: UIImage? = nil,
        video: String? = nil,
        audio: String? = nil,
        location: String? = nil,
        audioDuration: Float = 0.0
    ) {
        OutgoingMessage.send(
            chatId: chatId,
            text: text,
            photo: photo,
            video: video,
            audio: audio,
            audioDuration: audioDuration, 
            location: location,
            memberIds: [User.currentId, "recipientId"]
        )
    }
}








