//
//  StockQuoteViewController.swift
//  StockSurge
//
//  Created by John Pappas on 12/15/20.
//  Copyright © 2020 John Pappas. All rights reserved.
//

import UIKit

class StockQuoteViewController: UIViewController {
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var dayOpenLabel: UILabel!
    @IBOutlet weak var dayHighLabel: UILabel!
    @IBOutlet weak var dayLowLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
    @IBOutlet weak var comSymbol: UILabel!
    @IBOutlet weak var buyRecLabel: UILabel!
    @IBOutlet weak var holdRecLabel: UILabel!
    @IBOutlet weak var sellRecLabel: UILabel!
    
    var symbol = ""
    var stock: Stock!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stock.getStockData(companySymbol: symbol) {
            DispatchQueue.main.async {
                self.comSymbol.text = self.stock.symbol
                self.dayHighLabel.text = "$\(self.stock.dayHigh)"
                self.dayLowLabel.text = "$\(self.stock.dayLow)"
                self.dayOpenLabel.text = "$\(self.stock.dayOpen)"
                self.currentPriceLabel.text = "$\(self.stock.currentPrice)"
                if self.stock.dayChange < 0.0 {
                    self.percentChangeLabel.textColor = UIColor.systemRed
                } else {
                    self.percentChangeLabel.textColor = UIColor.systemGreen
                }
                self.percentChangeLabel.text = "\(self.stock.dayChange.rounded())%"
            }
        }
        stock.getStockRec(companySymbol: symbol) {
            DispatchQueue.main.async {
                self.buyRecLabel.text = "\(self.stock.resultArray[0].buy)"
                self.holdRecLabel.text = "\(self.stock.resultArray[0].hold)"
                self.sellRecLabel.text = "\(self.stock.resultArray[0].sell)"
            }
        }
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BuyStockSegue" {
            let destination = segue.destination as! BuyOrSellViewController
            destination.symbol = self.symbol        }
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
}

