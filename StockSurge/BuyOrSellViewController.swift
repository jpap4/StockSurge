//
//  BuyOrSellViewController.swift
//  StockSurge
//
//  Created by John Pappas on 12/16/20.
//  Copyright © 2020 John Pappas. All rights reserved.
//

import UIKit

class BuyOrSellViewController: UIViewController {
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var dayOpenLabel: UILabel!
    @IBOutlet weak var dayHighLabel: UILabel!
    @IBOutlet weak var dayLowLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
    @IBOutlet weak var comSymbol: UILabel!
    @IBOutlet weak var orderTotal: UILabel!
    @IBOutlet weak var sharesForTransaction: UITextField!
    @IBOutlet weak var orderTotalLabel: UILabel!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var submitOrderButton: UIButton!
    @IBOutlet weak var numSharesOwned: UILabel!
    @IBOutlet weak var shareAmount: UILabel!
    
    var stock: Stock!
    var changePercent = 0.0
    var numShares = 0.0
    var orderAmount = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        if stock == nil {
            stock = Stock()
        }
        updateUserInterface()


    }
    
    
    func updateUserInterface() {
        self.companySymbolLabel.text = stock.symbol
        self.dayHighLabel.text = "$\(stock.dayHigh)"
        self.dayLowLabel.text = "$\(stock.dayLow)"
        self.dayOpenLabel.text = "$\(stock.dayOpen)"
        self.currentPriceLabel.text = "$\(stock.currentPrice)"
        self.numSharesOwned.text = "\(stock.sharesOwned)"
        changePercent = ((stock.currentPrice/stock.dayOpen) - 1) * 100
        if self.changePercent < 0.0 {
            self.percentChangeLabel.textColor = UIColor.systemRed
        } else {
            self.percentChangeLabel.textColor = UIColor.systemGreen
        }
        self.percentChangeLabel.text = String(format: "%.2f", changePercent) + "%"
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    
    @IBAction func calculateOrderPressed(_ sender: UIButton) {
        self.numShares = (Double(Int(sharesForTransaction.text!) ?? 0))
        self.orderAmount = stock.currentPrice * numShares
        self.orderTotalLabel.text = "$" + String(format: "%.2f", orderAmount) 
        sharesForTransaction.resignFirstResponder()
        
    }
    

    @IBAction func submitOrderPressed(_ sender: UIButton) {
        self.numShares = (Double(Int(sharesForTransaction.text!) ?? 0))
        self.orderAmount = stock.currentPrice * numShares
        stock.sharesOwned = stock.sharesOwned + self.numShares
        stock.fundsInvested = stock.fundsInvested + self.orderAmount
        stock.currentValue = stock.sharesOwned * stock.currentPrice
        stock.dayChange = stock.currentPrice/stock.dayOpen - 1
        stock.totalGainLoss = stock.currentValue/stock.fundsInvested - 1
        stock.purchaseOrder.append(self.numShares)
        stock.purchasePrice.append(stock.currentPrice)
        stock.saveData { (success) in
            if success {
                let isPresentingInAddMode = self.presentingViewController is UINavigationController
                if isPresentingInAddMode {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.oneButtonAlert(title: "Save Failed", message: "Data Would not Save to Cloud")
            }
}
    }

}
