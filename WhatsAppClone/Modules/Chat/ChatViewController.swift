import UIKit
import MessageKit
import InputBarAccessoryView
import RealmSwift

final class ChatViewController: MessagesViewController {
    public let recent: Recent
    private let refreshControl = UIRefreshControl()
    public let micButton = InputBarButtonItem()
    public let currentUser = MKSender(senderId: Person.currentId, displayName: Person.currentName)
    public var mkMessages: [MKMessage] = []
    private var isTyping = false
    
    private lazy var chatTitleView = ChatTitleView(name: recent.name,
                                         frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    init(recent: Recent) {
        self.recent = recent
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageCollectionView()
        configureMessageInputBar()
    }
    
    // MARK: - Configure
    private func configureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self

        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnInputBarHeightChanged = true

        messagesCollectionView.refreshControl = refreshControl
    }
    
    private func configureMessageInputBar() {
        messageInputBar.delegate = self
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.onTouchUpInside {[weak self] _ in self?.actionAttachMessage()}

        micButton.image = UIImage(systemName: "mic.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)

        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground

//        updateMicButtonStatus(show: true)
        // add gesutre recognizer
    }
    
    private func actionAttachMessage() {
        print(#function)
    }
}
// MARK: - Typing
extension ChatViewController {
    func updateTypingIndicator(_ show: Bool) {
        chatTitleView.configure(with: show)
    }

    func typingIndicatorUpdate() {
        if !isTyping {
            isTyping = true
            FirebaseClient.shared.saveTyping(typing: true, chatRoomId: recent.chatRoomId)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.typingCounterStop()
            }
        }
    }

    func typingCounterStop() {
        isTyping = false
        FirebaseClient.shared.saveTyping(typing: false, chatRoomId: recent.chatRoomId)
    }

    func createTypingObserver() {
        FirebaseClient.shared.createTypingObserver(chatRoomId: recent.chatRoomId) { typing in
            DispatchQueue.main.async {
                self.updateTypingIndicator(typing)
            }
        }
    }
}
