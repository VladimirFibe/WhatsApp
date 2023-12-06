import UIKit
import MessageKit
import InputBarAccessoryView
import RealmSwift
import Photos
import PhotosUI
import ProgressHUD

final class ChatViewController: MessagesViewController {
    private let recent: Recent

    var displayingMessagesCount = 0
    var maxMessageNumber = 0
    var minMessageNumber = 0
    var typingCounter = 0

    let currentUser = MKSender(senderId: Person.currentId, displayName: "Current User")
    private let refreshControl = UIRefreshControl()

    private let micButton = InputBarButtonItem()

    var mkMessages: [MKMessage] = []
    var allLocalMessages: Results<Message>!
    let realm = try! Realm()

    var notificationToken: NotificationToken?

    //MARK: - Views
    let leftBarButtonView: UIView = {
        return UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    }()

    let titleLabel: UILabel = {
       let title = UILabel(frame: CGRect(x: 5, y: 0, width: 180, height: 25))
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        title.adjustsFontSizeToFitWidth = true
        return title
    }()

    let subTitleLabel: UILabel = {
       let subTitle = UILabel(frame: CGRect(x: 5, y: 22, width: 180, height: 20))
        subTitle.textAlignment = .left
        subTitle.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        subTitle.adjustsFontSizeToFitWidth = true
        return subTitle
    }()

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
        configureNavBar()
        updateMicButtonStatus(show: true)
        loadChats()
        listenForNewChats()
        listenForReadStatusChange()
        createTypingObserver()
    }

    init(recent: Recent) {
        self.recent = recent
        super.init(nibName: nil, bundle: nil)
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

    private func configureNavBar() {
        configureCustomTitle()
        configureLeftBarButton()
    }

    private func configureLeftBarButton() {
        let leftButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonPressed)
        )
        let leftView = UIBarButtonItem(customView: leftBarButtonView)
        navigationItem.leftBarButtonItems = [leftButton, leftView]
    }

    private func configureCustomTitle() {
        leftBarButtonView.addSubview(titleLabel)
        leftBarButtonView.addSubview(subTitleLabel)
        titleLabel.text = recent.name
    }

    private func configureMesssageInputBar() {
        messageInputBar.delegate = self

        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(
            systemName: "plus",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)
        )
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.onTouchUpInside { item in
            self.actionAttachMessage()
        }
        micButton.image = UIImage(
            systemName: "mic.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)
        )
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

    func updateMicButtonStatus(show: Bool) {
        if show {
            messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        } else {
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        }
    }
}
// MARK: Actions
extension ChatViewController {
    @objc private func backButtonPressed() {
        FirebaseClient.shared.removeListeners()
        FirebaseClient.shared.resetUnreadCounter(recent: recent)
        navigationController?.popViewController(animated: true)
    }

    private func actionAttachMessage() {
        messageInputBar.inputTextView.resignFirstResponder()
        let optionMenu = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        let camera = UIAlertAction(title: "Camera", style: .default) { alert in
            self.showImageGallery(.camera)
        }
        let library = UIAlertAction(title: "Library", style: .default) { alert in
            self.showImageGallery(.photoLibrary)
        }
        let location = UIAlertAction(title: "Location", style: .default) { alert in
            print("Location")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        camera.setValue(UIImage(systemName: "camera"), forKey: "image")
        library.setValue(UIImage(systemName: "photo.fill"), forKey: "image")
        location.setValue(UIImage(systemName: "mappin.and.ellipse"), forKey: "image")
        [camera, library, location, cancel].forEach { optionMenu.addAction($0)}
        self.present(optionMenu, animated: true)
    }

    private func loadChats() {
        let predicate = NSPredicate(format: "chatRoomId = %@", Person.chatRoomIdFrom(id: recent.chatRoomId))
        allLocalMessages = realm
            .objects(Message.self)
            .filter(predicate)
            .sorted(byKeyPath: kDATE, ascending: true)
        
        if allLocalMessages.isEmpty {
            checkForOldChats()
        }
        
        notificationToken = allLocalMessages.observe({ changes in
            switch changes {
            case .initial:
                self.insertMessages()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
            case .update(_, _, let insertions, _):
                for index in insertions {
                    self.appendMessage(self.allLocalMessages[index])
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem()
                }
            case .error(let error):
                print("Error on new insertion ", error.localizedDescription)
            }
        })
    }

    private func listenForNewChats() {
        var lastMessageDate = allLocalMessages.last?.date ?? Date()
        lastMessageDate = Calendar.current.date(byAdding: .second, value: 1, to: lastMessageDate) ?? lastMessageDate
        FirebaseClient.shared.listenForNewChats(Person.currentId, friendUid: recent.chatRoomId, lastMessageDate: lastMessageDate)
    }

    private func listenForReadStatusChange() {
        FirebaseClient.shared.listenForReadStatusChanges(Person.currentId, friendUid: recent.chatRoomId) { message in
            self.updateMessage(message)
        }
    }

    private func checkForOldChats() {
        FirebaseClient.shared.checkForOldChats(Person.currentId, friendUid: recent.chatRoomId)
    }

    private func insertMessages() {
        maxMessageNumber = allLocalMessages.count - displayingMessagesCount
        minMessageNumber = maxMessageNumber - kNUMBEROFMESSAGES

        if minMessageNumber < 0 {
            minMessageNumber = 0
        }

        for i in (minMessageNumber ..< maxMessageNumber).reversed() {
            insertMessage(allLocalMessages[i])
        }
    }

    private func insertMessage(_ message: Message) {
        let incoming = IncomingMessage(self)
        if let mkMessage = incoming.createMessage(message) {
            mkMessages.insert(mkMessage, at: 0)
            markMessageAsRead(message)
        }
    }

    private func appendMessage(_ message: Message) {
        let incoming = IncomingMessage(self)
        if let mkMessage = incoming.createMessage(message) {
            mkMessages.append(mkMessage)
            markMessageAsRead(message)
        }
    }

    private func updateMessage(_ message: Message) {
        for index in mkMessages.indices {
            if message.id == mkMessages[index].messageId {
                mkMessages[index].status = message.status
                mkMessages[index].readDate = message.readDate
                RealmManager.shared.saveToRealm(message)
                messagesCollectionView.reloadData()
            }
        }
    }

    private func markMessageAsRead(_ message: Message) {
        displayingMessagesCount += 1
        if message.uid != Person.currentId {
            FirebaseClient.shared.updateMessageInFireStore(message)
        }
    }

    func messageSend(
        text: String? = nil,
        photo: UIImage? = nil,
        video: String? = nil,
        audio: String? = nil,
        location: String? = nil,
        audioDuration: Float = 0.0
    ) {
        OutgoingMessage.send(
            recent: recent,
            text: text,
            photo: photo,
            video: video,
            audio: audio,
            audioDuration: audioDuration, 
            location: location,
            memberIds: [User.currentId, recent.chatRoomId]
        )
    }

    // MARK: - Update Typing Indicator
    func updateTypingIndicator(_ show: Bool) {
        subTitleLabel.text = show ? "Typing..." : ""
    }

    func typingIndicatorUpdate() {
        typingCounter += 1
        FirebaseClient.shared.saveTyping(typing: true, chatRoomId: recent.chatRoomId)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.typingCounterStop()
        }
    }

    func typingCounterStop() {
        typingCounter -= 1
        if typingCounter == 0 {
            FirebaseClient.shared.saveTyping(typing: false, chatRoomId: recent.chatRoomId)
        }
    }

    func createTypingObserver() {
        FirebaseClient.shared.createTypingObserver(chatRoomId: recent.chatRoomId) { typing in
            DispatchQueue.main.async {
                self.updateTypingIndicator(typing)
            }
        }
    }

    // MARK: - UIScrollViewDelegate
    override func scrollViewDidEndDecelerating(_: UIScrollView) {
        if refreshControl.isRefreshing {
            if displayingMessagesCount < allLocalMessages.count {
                insertMessages()
                messagesCollectionView.reloadDataAndKeepOffset()
            }
            refreshControl.endRefreshing()
        }
    }

    // MARK: - ImagePicker
    private func showImageGallery(_ sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension ChatViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = info[.editedImage] as? UIImage  {
            messageSend(photo: image)
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ChatViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
//        guard let result = results.first else { return }
//        let progress = result.itemProvider.loadTransferable(type: Data.self) { result in
//            print("DEBUG: video")
//        }
//        Task {
//            do {
//
//            } catch {}
//        }

//        result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
//            if let _ = reading as? UIImage, error == nil {
//                ProgressHUD.succeed("Выбрано изображение")
//                return
//            }
//            DispatchQueue.main.async {
////                self.photoCell.configrure(with: image)
//            }
//        }
    }

    func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .videos
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}





