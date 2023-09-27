//
//  BaseTableViewCell.swift
//  WhatsApp
//
//  Created by Vladimir Fibe on 27.09.2023.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}


@objc extension BaseTableViewCell {
    func setupViews() {}
    func setupConstraints() {}
}
