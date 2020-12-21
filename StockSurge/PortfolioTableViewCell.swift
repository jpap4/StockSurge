//
//  PortfolioTableViewCell.swift
//  StockSurge
//
//  Created by John Pappas on 12/16/20.
//  Copyright © 2020 John Pappas. All rights reserved.
//

import UIKit

class PortfolioTableViewCell: UITableViewCell {
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var companyPriceLabel: UILabel!
    @IBOutlet weak var companyDailyChangeLabel: UILabel!
    
    var changePercent = 0.0
    var stock: Stock! {
        didSet {
            companySymbolLabel.text = "\(stock.symbol)"
            companyPriceLabel.text = "\(stock.currentPrice)"
            changePercent = ((stock.currentPrice/stock.dayOpen) - 1) * 100
            if self.changePercent < 0.0 {
                self.companyDailyChangeLabel.textColor = UIColor.systemRed
            } else {
                self.companyDailyChangeLabel.textColor = UIColor.systemGreen
            }
            self.companyDailyChangeLabel.text = String(format: "%.2f", changePercent) + "%"


            return
            }
        }
    }
    
    
