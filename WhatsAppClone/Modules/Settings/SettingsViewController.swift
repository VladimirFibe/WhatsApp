//
//  SettingsViewController.swift
//  WhatsAppClone
//
//  Created by Vladimir Fibe on 05.12.2024.
//

import UIKit
import FirebaseAuth

final class SettingsViewController: UIViewController {
    var callback: Callback?
    
    init(callback: Callback? = nil) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }
    
    @objc private func done() {
        try? Auth.auth().signOut()
        callback?()
    }
}
