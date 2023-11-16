import UIKit
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
    }

    override func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
// MARK: -
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
}
// MARK: - UITableViewDelegate
extension EditProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
//            model.profileStatusHandler?()
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
            guard let image = reading as? UIImage, error == nil else { return }
            DispatchQueue.main.async {
                self.photoCell.configrure(with: image)
            }
            self.store.sendAction(.uploadImage(image))
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
