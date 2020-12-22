//
//  HoldingsTableViewCell.swift
//  StockSurge
//
//  Created by John Pappas on 12/22/20.
//  Copyright © 2020 John Pappas. All rights reserved.
//

import UIKit

class HoldingsTableViewCell: UITableViewCell {
    @IBOutlet weak var shareQuantityLabel: UILabel!
    @IBOutlet weak var purchasePriceLabel: UILabel!
    
    var stock: Stock! {
        didSet {
            shareQuantityLabel.text = "\(stock.purchaseOrder)"
            purchasePriceLabel.text = "$" + String(format: "%.2f", stock.purchasePrice)
            return
        }
    }
}
