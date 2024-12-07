import UIKit
import Photos
import PhotosUI
import ProgressHUD

final class EditProfileViewController: UITableViewController {
    private var bag = Bag()
    private let store = EditProfileStore()
    private let photoCell = PhotoTableViewCell()
    private let textFieldCell = TextFieldTableViewCell()
    private let statusCell = UITableViewCell()
    private var person: Person
    
    init(person: Person) {
        self.person = person
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Profile"
        statusCell.selectionStyle = .none
        statusCell.accessoryType = .disclosureIndicator
        setupPhotoTableViewCell()
        setupTextFieldCell()
        showUserInfo()
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
            return statusCell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let controller = UIViewController()
            navigationController?.pushViewController(controller, animated: true)
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
        textFieldCell.configure(with: person.username)
        var config = statusCell.defaultContentConfiguration()
        config.text = person.status.text
        statusCell.contentConfiguration = config

        FileStorage.downloadImage(id: person.id, link: person.avatarLink) { image in
            self.photoCell.configure(with: image)
        }
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
        let id = person.id
        FileStorage.uploadImage(image, directory: "/profile/\(id).jpg") { avatarLink in
            if let avatarLink {
                self.store.sendAction(.updateAvatarLink(avatarLink))
                ProgressHUD.succeed("Аватар сохранен")
                guard let data = image.jpegData(compressionQuality: 1.0) as? NSData else { return }
                FileStorage.saveFileLocally(data, fileName: "\(id).jpg")
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
