//
//  SellViewController.swift
//  StockSurge
//
//  Created by John Pappas on 12/22/20.
//  Copyright © 2020 John Pappas. All rights reserved.
//

import UIKit

class SellViewController: UIViewController {
    @IBOutlet weak var numberOfSharesLabel: UILabel!
    @IBOutlet weak var purchasePriceLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var totalGainLossLabel: UILabel!
    @IBOutlet weak var submitOrderButton: UIButton!
    
    var stock: Stock!
    var totalGainLoss = 0.0
    var numberShares = 0.0
    var purchasePrice = 0.0
    var indexP = 0
    var indexO = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfSharesLabel.text = "\(numberShares)"
        purchasePriceLabel.text = "\(purchasePrice)"
        totalCostLabel.text = "\(numberShares * purchasePrice)"
        currentPriceLabel.text = "\(stock.currentPrice)"
        currentValueLabel.text = "\(stock.currentPrice * numberShares)"
        totalGainLoss = stock.currentPrice * numberShares - (numberShares * purchasePrice)
        totalGainLossLabel.text =  "$" + String(format: "%.2f", totalGainLoss)
        print(indexO)
        print(indexP)
    }
    


    @IBAction func sellButtonPressed(_ sender: UIButton) {
        self.stock.fundsInvested -= (purchasePrice * numberShares)
        self.stock.sharesOwned -=  numberShares
        self.stock.currentValue = stock.sharesOwned * stock.currentPrice
        self.stock.totalGainLoss = (stock.currentValue/stock.fundsInvested - 1) * 100
        stock.purchaseOrder.remove(at: Int(indexO))
        stock.purchasePrice.remove(at: Int(indexP))
        self.stock.saveData { (success) in
            if success {
                let isPresentingInAddMode = self.presentingViewController is UINavigationController
                if isPresentingInAddMode {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
                print("Successful Save")
            } else {
                print("Save Failed")
            }
        }
        if stock.sharesOwned == 0.0 {
            stock.deleteData(stock: stock) { (success) in
                if success {
                    print("good")
                }
            }
        }
    }
    
}
