//
//  SettingsViewController.swift
//  WhatsAppClone
//
//  Created by MacService on 22.05.2024.
//

import UIKit

class SettingsViewController: UITableViewController {
    private var callback: Callback?
    private let store = SettingsStore()
    private var bag = Bag()

    init(callback: Callback? = nil) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in self.store.sendAction(.signOut)})
        setupObservers()
        print(Person.localPerson)
//        showUserInfo(Person.localPerson)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.sendAction(.fetch)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}

extension SettingsViewController {
    private func setupObservers() {
        store
            .events
            .receive(on: DispatchQueue.main)
            .sink {[weak self] event in
                switch event {
                case .done: self?.showUserInfo(FirebaseClient.shared.person)
                case .signOut: self?.callback?()
                }
            }.store(in: &bag)
    }

    private func showUserInfo(_ person: Person?) {
        if let person {
//            userInfoCell.configure(with: person)
//            FileStorage.downloadImage(id: person.id, link: person.avatarLink) { image in
//                self.userInfoCell.configure(with: image?.circleMasked)
//            }
//            print(person)
        }
    }
}
