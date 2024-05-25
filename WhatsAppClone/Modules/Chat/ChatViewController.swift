import UIKit
import PhotosUI
import MessageKit
import InputBarAccessoryView
import RealmSwift

final class ChatViewController: MessagesViewController {
    let recent: Recent
    private var selection = [String: PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    private var selectedAssetIdentifierIterator: IndexingIterator<[String]>?
    private var currentAssetIdentifier: String?

    let currentUser = MKSender(senderId: Person.currentId, displayName: Person.currentName)
    let refreshControl = UIRefreshControl()
    private lazy var chatTitleView = ChatTitleView(name: recent.name,
                                         frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    let micButton = InputBarButtonItem()
    var mkMessages: [MKMessage] = [] {
        didSet {
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem()
        }
    }
    var messages: Results<Message>!
    let realm = try! Realm()
    var notificationToken: NotificationToken?
    var isTyping = false
    var displayingMessagesCount = 0

    init(recent: Recent) {
        self.recent = recent
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureMessageInputBar()
        configureMessageCollectionView()
        configureLeftBarButton()

        loadChats()
        listenForNewChats()
        listenForReadStatusChange()
        createTypingObserver()
    }

    private func configureLeftBarButton() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         primaryAction: UIAction {[weak self] _ in self?.backButtonPressed()})
        let leftView = UIBarButtonItem(customView: chatTitleView)
        navigationItem.leftBarButtonItems = [leftButton, leftView]
    }

    private func backButtonPressed() {
        FirebaseClient.shared.removeListeners()
        FirebaseClient.shared.resetUnreadCounter(recent: recent)
        navigationController?.popViewController(animated: true)
    }

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
        attachButton.onTouchUpInside { _ in self.actionAttachMessage()}

        micButton.image = UIImage(systemName: "mic.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)

        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground

        updateMicButtonStatus(show: true)
        // add gesutre recognizer
    }

    private func actionAttachMessage() {
        messageInputBar.inputTextView.resignFirstResponder()
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { alert in
            self.showImageGallery(.camera)
        }
        let library = UIAlertAction(title: "Library", style: .default) { alert in
            self.presentPicker()
        }
        let location = UIAlertAction(title: "Location", style: .default) { alert in
//            if LocationManager.shared.currentLocation != nil {
//                self.messageSend(location: kLOCATION)
//            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        camera.setValue(UIImage(systemName: "camera"), forKey: "image")
        library.setValue(UIImage(systemName: "photo.fill"), forKey: "image")
        location.setValue(UIImage(systemName: "mappin.and.ellipse"), forKey: "image")
        [camera, library, location, cancel].forEach { optionMenu.addAction($0)}
        self.present(optionMenu, animated: true)
    }
}
// MARK: - Load Chats
extension ChatViewController {
    private func loadChats() {
        let predicate = NSPredicate(format: "chatRoomId = %@", recent.chatRoomId)
        messages = realm.objects(Message.self).filter(predicate).sorted(byKeyPath: kDATE, ascending: true)
        if messages.isEmpty { checkForOldChats() }
        notificationToken = messages.observe({ changes in
            switch changes {
            case .initial:
                self.insertMessages()

            case .update(_, _, let insertions, _):
                for index in insertions {
                    self.insertMessage(self.messages[index])
                }
            case .error(let error):
                print("Error on new insertion ", error.localizedDescription)
            }
        })
    }

    private func insertMessages() {
        messages.forEach {
            insertMessage($0)
        }
    }

    private func insertMessage(_ message: Message) {
        let incoming = IncomingMessage(self)

        if let mkMessage = incoming.createMessage(message) {
            mkMessages.append(mkMessage)
            markMessageAsRead(message)
        }
    }

    private func markMessageAsRead(_ message: Message) {
        displayingMessagesCount += 1
        if message.uid != Person.currentId, message.status != kREAD {
            FirebaseClient.shared.updateMessageInFireStore(message)
        }
    }
}
// MARK: - Firebase chats
extension ChatViewController {
    private func listenForNewChats() {
        var lastMessageDate = messages.last?.date ?? Date()
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

    private func updateMessage(_ message: Message) {
        for index in mkMessages.indices {
            if message.id == mkMessages[index].messageId {
                mkMessages[index].status = message.status
                mkMessages[index].readDate = message.readDate
                RealmManager.shared.saveToRealm(message)
                messagesCollectionView.reloadData()
                return
            }
        }
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
// MARK: - Image Picker
extension ChatViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private func showImageGallery(_ sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
        print(picker.mediaTypes)
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

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
        dismiss(animated: true)

        let existingSelection = self.selection
        var newSelection = [String: PHPickerResult]()
        for result in results {
            let identifier = result.assetIdentifier!
            newSelection[identifier] = existingSelection[identifier] ?? result
        }

        // Track the selection in case the user deselects it later.
        selection = newSelection
        selectedAssetIdentifiers = results.map(\.assetIdentifier!)
        selectedAssetIdentifierIterator = selectedAssetIdentifiers.makeIterator()

        if !selection.isEmpty {
            saveAsset()
        }
    }


    private func presentPicker(filter: PHPickerFilter? = nil) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())

        // Set the filter type according to the user’s selection.
        configuration.filter = filter
        // Set the mode to avoid transcoding, if possible, if your app supports arbitrary image/video encodings.
        configuration.preferredAssetRepresentationMode = .current
        // Set the selection behavior to respect the user’s selection order.
        configuration.selection = .ordered
        // Set the selection limit to enable multiselection.
        configuration.selectionLimit = 1
        // Set the preselected asset identifiers with the identifiers that the app tracks.
        configuration.preselectedAssetIdentifiers = selectedAssetIdentifiers

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    func saveAsset() {
        guard let assetIdentifier = selectedAssetIdentifierIterator?.next() else { return }
        currentAssetIdentifier = assetIdentifier

        let progress: Progress?
        let itemProvider = selection[assetIdentifier]!.itemProvider
        if itemProvider.canLoadObject(ofClass: PHLivePhoto.self) {
            progress = itemProvider.loadObject(ofClass: PHLivePhoto.self) { [weak self] livePhoto, error in
                DispatchQueue.main.async {
                    self?.handleCompletion(assetIdentifier: assetIdentifier, object: livePhoto, error: error)
                }
            }
        }
        else if itemProvider.canLoadObject(ofClass: UIImage.self) {
            progress = itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    self?.handleCompletion(assetIdentifier: assetIdentifier, object: image, error: error)
                }
            }
        } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
            progress = itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] url, error in
                do {
                    guard let url = url, error == nil else {
                        throw error ?? NSError(domain: NSFileProviderErrorDomain, code: -1, userInfo: nil)
                    }
                    self?.messageSend(videoUrl: url)
                } catch let catchedError {
                    DispatchQueue.main.async {
                        self?.handleCompletion(
                            assetIdentifier: assetIdentifier,
                            object: nil,
                            error: catchedError
                        )
                    }
                }
            }
        } else {
            progress = nil
        }
        print(progress?.fractionCompleted ?? 0.0)
    }

    func handleCompletion(assetIdentifier: String, object: Any?, error: Error? = nil) {
        guard currentAssetIdentifier == assetIdentifier else { return }
        if let image = object as? UIImage {
            messageSend(photo: image)
        }
    }
}

