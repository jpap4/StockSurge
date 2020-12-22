//
//  PortfolioViewController.swift
//  StockSurge
//
//  Created by John Pappas on 12/16/20.
//  Copyright © 2020 John Pappas. All rights reserved.
//

import UIKit
import Firebase

class PortfolioViewController: UIViewController {
    @IBOutlet weak var portfolioValueLabel: UILabel!
    @IBOutlet weak var portfolioTotalGainLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var stock: Stock!
    var stocks: Stocks!
    var accountValue = 0.0
    var allTimeReturn = 0.0
    var totalInvestedFunds = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        portfolioValueLabel.text = "\(accountValue)"
        portfolioTotalGainLabel.text = "\(totalInvestedFunds)"
        stocks = Stocks()
        stock = Stock()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
        
        stocks.loadData {
            self.tableView.reloadData()
        }

        for stock2 in stocks.stockArray {
            print(stock2)
            stock = stock2
            stock.getStockData(ticker: stock.symbol) {
                DispatchQueue.main.async {
                    self.stock.currentValue = self.stock.currentPrice * self.stock.sharesOwned
                    self.stock.dayChange = (self.stock.currentPrice/self.stock.dayOpen) - 1
                    self.stock.totalGainLoss = (self.stock.currentValue/self.stock.fundsInvested) - 1
                    stock2.saveData { (success) in
                        if success {
                            return
                        } else {
                            self.oneButtonAlert(title: "Save Failed", message: "Data would not save to cloud.")
                        }
                    }
                }
            }
            
        }
        
        for stock2 in stocks.stockArray {
            stock = stock2
            accountValue += stock.currentValue
            totalInvestedFunds += stock.fundsInvested
            portfolioValueLabel.text = "$" + String(format: "%.2f", accountValue)
            if (accountValue/totalInvestedFunds - 1) * 100 < 0.0 {
                self.portfolioTotalGainLabel.textColor = UIColor.systemRed
            } else {
                self.portfolioTotalGainLabel.textColor = UIColor.systemGreen
            }
            portfolioTotalGainLabel.text = "Return: " + String(format: "%.2f", (accountValue/totalInvestedFunds - 1) * 100) + "%"

        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "ShowStockDetail" :
            let destination = segue.destination as! StockSearchViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow
            destination.navigationController?.setToolbarHidden(true, animated: true)
            destination.stock = stocks.stockArray[selectedIndexPath!.row]
            self.accountValue = 0.0
            self.totalInvestedFunds = 0.0
        case "AddStockDetail":
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.viewControllers.first as! StockSearchViewController
            self.accountValue = 0.0
            self.totalInvestedFunds = 0.0
        case "ShowAboutSegue":
            let destination = segue.destination as! AboutViewController
        default:
            print("Error56")
        }
    }
    
    @IBAction func refreshPressed(_ sender: UIButton) {
        if portfolioValueLabel.text == "\(0.0)"  &&  portfolioTotalGainLabel.text == "\(0.0)" {
            viewWillAppear(true)
        } else {
            return
        }
    }
    
}

extension PortfolioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return stocks.stockArray.count
        return stocks.stockArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PortfolioTableViewCell
        cell.stock = stocks.stockArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
