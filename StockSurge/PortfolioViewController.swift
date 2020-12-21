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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        portfolioValueLabel.text = "\(accountValue)"
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
            portfolioValueLabel.text = "\(accountValue)"
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "ShowStockDetail" :
            let destination = segue.destination as! StockSearchViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow
            destination.stock = stocks.stockArray[selectedIndexPath!.row]
            self.accountValue = 0.0
        case "AddStockDetail":
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.viewControllers.first as! StockSearchViewController
            self.accountValue = 0.0
        default:
            print("Error56")
        }
    }
    
    @IBAction func refreshPressed(_ sender: UIButton) {
        if portfolioValueLabel.text == "\(0.0)" {
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
