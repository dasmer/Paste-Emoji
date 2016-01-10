//
//  Value1TableViewCell.swift
//  Paste
//
//  Created by Dasmer Singh on 1/10/16.
//  Copyright © 2016 Dastronics Inc. All rights reserved.
//

import UIKit

/// A standard UITableViewCell that has default style: UITableViewCellStyle.Value1
final class TableViewCell: UITableViewCell {

    static let reuseIdentifier = NSStringFromClass(TableViewCell)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}