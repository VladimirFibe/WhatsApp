import UIKit
import ProgressHUD
import Photos
import PhotosUI

final class EditProfileViewController: BaseViewController {
    private let useCase = EditProfileUseCase(apiService: FirebaseClient.shared)
    private lazy var store = EditProfileStore(useCase: useCase)
    private let tableView: UITableView = {
        return $0
    }(UITableView(frame: .zero, style: .grouped))

    private lazy var photoCell: PhotoTableViewCell = {
        $0.selectionStyle = .none
        $0.configure(self, action: #selector(editButtonTapped))
        return $0
    }(PhotoTableViewCell())

    private lazy var textFieldCell: TextFieldTableViewCell = {
        $0.configure(delegate: self)
        $0.selectionStyle = .none
        return $0
    }(TextFieldTableViewCell())

    private lazy var statusCell: StatusTableViewCell = {
        $0.accessoryType = .disclosureIndicator
        $0.selectionStyle = .none
        return $0
    }(StatusTableViewCell())

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.sendAction(.fetch)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
// MARK: - Setup
extension EditProfileViewController {
    override func setupViews() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "Edit Profile"
        setupObservers()
        showUserInfo(Person.localPerson)
    }

    private func setupObservers() {
        store
            .events
            .receive(on: DispatchQueue.main)
            .sink {[weak self] event in
                switch event {
                case .done:
                    self?.showUserInfo(FirebaseClient.shared.person)
                }
            }.store(in: &bag)
    }

    override func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func showUserInfo(_ person: Person?) {
        if let person {
            textFieldCell.configure(person.username)
            statusCell.textLabel?.text = person.status
            FileStorage.downloadImage(id: person.id, link: person.avatarLink) { image in
                self.photoCell.configrure(with: image?.circleMasked)
            }
        }
    }
}
// MARK: - UITableViewDataSource
extension EditProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 2 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return photoCell
            } else {
                return textFieldCell
            }
        } else {
            return statusCell
        }
    }
}
// MARK: - Actions
extension EditProfileViewController {
    @objc func editButtonTapped() {
        presentPhotoPicker()
    }

    private func uploadAvatarImage(_ image: UIImage) {
        guard let id = FirebaseClient.shared.person?.id else { return }
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
// MARK: - UITableViewDelegate
extension EditProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let controller = ProfileStatusViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textFieldCell.text.isEmpty {
            store.sendAction(.updateUsername(textFieldCell.text))
        }
        return true
    }
}
// MARK: - PHPickerViewControllerDelegate
extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
            guard let image = reading as? UIImage, error == nil else { 
                ProgressHUD.failed("Выберите другое изображение")
                return
            }
            DispatchQueue.main.async {
                self.photoCell.configrure(with: image)
            }
            self.uploadAvatarImage(image)
        }
    }

    func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}