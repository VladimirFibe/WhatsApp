import UIKit

final class MyChannelsViewController: BaseTableViewController {
    private var channels: [Channel] = []
}
// MARK: - Setup Views
extension MyChannelsViewController {
    override func setupViews() {
        super.setupViews()
        tableView.register(
            ChannelsCell.self, 
            forCellReuseIdentifier: ChannelsCell.identifier
        )
        navigationItem.title = "My Channels"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction(handler: { _ in
            let channel = Channel(memberIds: [Person.currentId])
            let controller = AddChannelViewController(channel: channel)
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        downloadChannels()
    }
}
// MARK: - Actions
extension MyChannelsViewController {
    @objc private func backButtonTapped() {
        FirebaseClient.shared.myChannelsListener?.remove()
        navigationController?.popViewController(animated: true)
    }
    private func downloadChannels() {
        FirebaseClient.shared.downloadUserChannelsFromFirebase { channels in
            DispatchQueue.main.async {
                self.channels = channels
                self.tableView.reloadData()
            }
        }
    }
}
// MARK: - Data Source
extension MyChannelsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        channels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChannelsCell.identifier,
            for: indexPath
        ) as? ChannelsCell else { fatalError() }
        let channel = channels[indexPath.row]
        cell.configure(with: channel)
        return cell
    }
}
// MARK: - UITableViewDelegate
extension MyChannelsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let channel = channels[indexPath.row]
        let controller = AddChannelViewController(channel: channel)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FirebaseClient.shared.deleteChannel(channels[indexPath.row])
        }
    }
}
