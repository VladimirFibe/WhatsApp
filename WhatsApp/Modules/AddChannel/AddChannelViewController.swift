import UIKit
import ProgressHUD
import Photos
import PhotosUI

final class AddChannelViewController: BaseTableViewController {
    private let useCase = AddChannelUseCase(apiService: FirebaseClient.shared)
    private lazy var store = AddChannelStore(useCase: useCase)

    private var selection = [String: PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    private var selectedAssetIdentifierIterator: IndexingIterator<[String]>?
    private var currentAssetIdentifier: String?

    private var channel: Channel

    private lazy var photoCell: AddPhotoChannelCell = {
        return $0
    }(AddPhotoChannelCell())

    private lazy var aboutCell: AddAboutChannelCell = {
        return $0
    }(AddAboutChannelCell())

    private lazy var cancelButton = UIBarButtonItem(
        systemItem: .cancel, 
        primaryAction: UIAction(handler: { _ in
        self.navigationController?.popViewController(animated: true)
    }))

    private lazy var saveButton = UIBarButtonItem(
        systemItem: .save,
        primaryAction: UIAction(handler: { _ in
        self.save()
    }))

    init(channel: Channel) {
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Actions
extension AddChannelViewController {
    @objc private func addPhoto() {
        presentPicker(filter: .images)
    }
    private func save() {
        if let image = photoCell.image, !photoCell.text.isEmpty {
            cancelButton.isEnabled = false
            saveButton.isEnabled = false
            channel.name = photoCell.text
            channel.aboutChannel = aboutCell.text
            channel.adminId = Person.currentId
            store.sendAction(.save(image, channel))
        } else {
            ProgressHUD.failed("Empty field")
        }
    }
}
// MARK: - Setup Views
extension AddChannelViewController {
    override func setupViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        photoCell.configure(with: channel)
        aboutCell.configure(with: channel)
        photoCell.configure(tap)
        setupNavigationBar()
        setupObservers()
    }
    private func setupNavigationBar() {

        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = channel.name.isEmpty ? "Add Channel" : "Edit Channel"
    }
    private func setupObservers() {
        store
            .events
            .receive(on: DispatchQueue.main)
            .sink { event in
                weak var wSelf = self
                switch event {
                case .done:
                    wSelf?.navigationController?.popViewController(animated: true)
                case .error:
                    wSelf?.cancelButton.isEnabled = true
                    wSelf?.saveButton.isEnabled = true
                    ProgressHUD.failed()
                }
            }.store(in: &bag)
    }
}
// MARK: - Data Source
extension AddChannelViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            photoCell
        } else {
            aboutCell
        }
    }
}
// MARK: - PHPickerViewControllerDelegate
extension AddChannelViewController: PHPickerViewControllerDelegate {
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
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            progress = itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    self?.handleCompletion(assetIdentifier: assetIdentifier, object: image, error: error)
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
            photoCell.configure(with: image)
        }
    }

}





