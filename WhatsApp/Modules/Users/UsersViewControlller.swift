//
//  UsersViewControlller.swift
//  WhatsApp
//
//  Created by Vladimir Fibe on 20.11.2023.
//

import UIKit

final class UsersViewControlller: BaseViewController {
    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.register(UsersTableViewCell.self, forCellReuseIdentifier: UsersTableViewCell.identifier)
        return $0
    }(UITableView())
}

extension UsersViewControlller {
    override func setupViews() {
        super.setupViews()
        navigationItem.title = "Users"
        view.addSubview(tableView)
    }

    override func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension UsersViewControlller: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier, for: indexPath) as? UsersTableViewCell else { fatalError()}
        return cell
    }
}

extension UsersViewControlller: UITableViewDelegate {

}
