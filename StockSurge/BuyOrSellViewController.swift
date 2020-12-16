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
    @IBOutlet weak var numberOfShares: UITextField!
    @IBOutlet weak var orderTotal: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var sharesForTransaction: UITextField!
    @IBOutlet weak var orderTotalLabel: UILabel!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var submitOrderButton: UIButton!
    
    var symbol = ""
    
    var stock: Stock!
    
    var currentPrice = 0.0
    var numberShares = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stock.getStockData(companySymbol: symbol) {
            DispatchQueue.main.async {
                self.companySymbolLabel.text = self.stock.symbol
                self.dayHighLabel.text = "$\(self.stock.dayHigh)"
                self.dayLowLabel.text = "$\(self.stock.dayLow)"
                self.dayOpenLabel.text = "$\(self.stock.dayOpen)"
                self.currentPriceLabel.text = "$\(self.stock.currentPrice)"
                self.currentPrice = self.stock.currentPrice
                if self.stock.dayChange < 0.0 {
                    self.percentChangeLabel.textColor = UIColor.systemRed
                } else {
                    self.percentChangeLabel.textColor = UIColor.systemGreen
                }
                self.percentChangeLabel.text = "\(self.stock.dayChange.rounded())%"
            }
        }
    }
    @IBAction func valueChanged(_ sender: UITextField) {
        updateUI()
        sender.text = String(sender.text?.last ?? " ").trimmingCharacters(in: .whitespaces).uppercased()
        
    }
    
    @IBAction func editingEnded(_ sender: UITextField) {

    }
    
    func updateUI() {
        numberOfShares.resignFirstResponder()
        numberOfShares.text! = ""
        submitOrderButton.isEnabled = false
    }
    
    @IBAction func calculateOrderPressed(_ sender: UIButton) {
        numberShares = Int(Double(Int(numberOfShares.text!) ?? 0))
        orderTotalLabel.text = "\(stock.currentPrice * Double(numberShares))"
        numberOfShares.resignFirstResponder()

    }
    func sortSegmentedControl() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            orderTotalLabel.text = "\( -stock.currentPrice * Double(numberShares))"
        case 1:
            orderTotalLabel.text = "\(stock.currentPrice * Double(numberShares))"
        default:
            print("Error")
        }}
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "buyorsellmodally" {
            let destination = segue.destination as! PortfolioViewController
            destination.stock.currentPrice = self.currentPrice
        }}
    
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        sortSegmentedControl()
        }
    
    @IBAction func submitOrderPressed(_ sender: UIButton) {
        self.stock.saveData { (success) in success}
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func myPortfolioPressed(_ sender: UIBarButtonItem) {
    }
}
