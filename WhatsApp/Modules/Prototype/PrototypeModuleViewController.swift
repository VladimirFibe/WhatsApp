//
//  PrototypeModuleViewController.swift
//  WhatsApp
//
//  Created by Vladimir Fibe on 26.09.2023.
//

import UIKit

final class PrototypeModuleViewController: BaseViewController {
    struct Model {
        let pushUnitHandler: (() -> Void)?
        let pushModuleHandler: (() -> Void)?
        let closeUnitOrModuleHandler: (() -> Void)?
        let popToRootHandler: (() -> Void)?
        let modalModuleHandler: (() -> Void)?
        let modalUnitHandler: (() -> Void)?
        let closeModalHandler: (() -> Void)?
    }

    private let model: Model

    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        print("\(title ?? "")ViewController dealloc")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
