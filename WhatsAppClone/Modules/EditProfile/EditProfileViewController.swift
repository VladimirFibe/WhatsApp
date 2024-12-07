import UIKit
import Photos
import PhotosUI
import ProgressHUD

final class EditProfileViewController: UITableViewController {
    private var bag = Bag()
    private let store = EditProfileStore()
    private let photoCell = PhotoTableViewCell()
    private let textFieldCell = TextFieldTableViewCell()
    private var person: Person? { didSet { showUserInfo() }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPhotoTableViewCell()
        setupTextFieldCell()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.sendAction(.fetch)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return indexPath.row == 0 ? photoCell : textFieldCell
        } else {
            return UITableViewCell()
        }
    }
    
    private func setupPhotoTableViewCell() {
        photoCell.configure(with: UIAction(handler: {[weak self] _ in
            self?.presentPhotoPicker()
        }))
    }
    
    private func setupTextFieldCell() {
        textFieldCell.configure(delegate: self)
    }
    
    private func showUserInfo() {
        if let person {
            textFieldCell.configure(with: person.username)
            FileStorage.downloadImage(id: person.id, link: person.avatarLink) { image in
                self.photoCell.configure(with: image)
            }
        }
    }
    
    private func setupObservers() {
        store
            .events
            .receive(on: DispatchQueue.main)
            .sink {[weak self] event in
                switch event {
                case .done(let person): self?.person = person
                }
            }.store(in: &bag)
    }
}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
            guard let image = reading as? UIImage, error == nil else {
                ProgressHUD.failed("Выберите другое изображение")
                return
            }
            DispatchQueue.main.async {
                self.photoCell.configure(with: image)
                self.uploadAvatarImage(image)
            }
        }
    }
    
    private func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func uploadAvatarImage(_ image: UIImage) {
        guard let person else { return }
        FileStorage.uploadImage(image, directory: "/profile/\(person.id).jpg") { avatarLink in
            if let avatarLink {
                self.store.sendAction(.updateAvatarLink(avatarLink))
                ProgressHUD.succeed("Аватар сохранен")
                guard let data = image.jpegData(compressionQuality: 1.0) as? NSData else { return }
                FileStorage.saveFileLocally(data, fileName: "\(person.id).jpg")
            } else {
                ProgressHUD.failed("Аватар не сохранен")
            }
        }
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textFieldCell.text.isEmpty {
            store.sendAction(.updateUsername(textFieldCell.text))
        }
        view.endEditing(true)
        return true
    }
}
