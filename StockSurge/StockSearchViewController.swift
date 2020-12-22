//
//  StockSearchViewController.swift
//  StockSurge
//
//  Created by John Pappas on 12/15/20.
//  Copyright © 2020 John Pappas. All rights reserved.
//

import UIKit
import FirebaseUI


class StockSearchViewController: UIViewController {
    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var dayOpenLabel: UILabel!
    @IBOutlet weak var dayHighLabel: UILabel!
    @IBOutlet weak var dayLowLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
    @IBOutlet weak var comSymbol: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var getQuoteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var holdingsLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    
    var stock: Stock!
    var stocks: Stocks!
    var changePercent = 0.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        if stock == nil {
            stock = Stock()
            tableView.hide()
            holdingsLabel.hide()
            
        } else {
            cancelBarButton.hide()
            searchView.hide()
            getQuoteButton.hide()
            comSymbol.hide()
            titleLabel.text = "\(self.stock.symbol)"
            titleLabel.textAlignment = .center
        }
        updateUserInterface()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()

        if stock.documentID != "" {
            self.navigationController?.setToolbarHidden(true, animated: true)
        }
    }
    
    func disableTextEditing() {
        searchView.isHidden = true
        searchView.backgroundColor = .clear
    }
    
    func updateUserInterface() {
        comSymbol.text = "\(stock.symbol)"
        currentPriceLabel.text = "\(stock.currentPrice)"
        dayOpenLabel.text = "\(stock.dayOpen)"
        dayHighLabel.text = "\(stock.dayHigh)"
        dayLowLabel.text = "\(stock.dayLow)"
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "AddPurchaseOrder":
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.viewControllers.first as! BuyOrSellViewController
            destination.stock = stock
        case "ShowOrderDetail":
            let destination = segue.destination as! BuyOrSellViewController
            destination.stock = stock
        case "ShowSale":
            let destination = segue.destination as! SellViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow
            destination.stock = stock
            destination.purchasePrice = stock.purchasePrice[selectedIndexPath!.row]
            destination.indexP = selectedIndexPath!.row
            destination.numberShares = stock.purchaseOrder[selectedIndexPath!.row]
            destination.indexO = selectedIndexPath!.row
        default:
            print("Error")
        }
    }
    
    @IBAction func getQuotePressed(_ sender: UIButton) {
        stock.getStockData(ticker: searchView.text!) {
            DispatchQueue.main.async {
                self.updateUserInterface()
            }
        }
    }
    
    @IBAction func placeOrderPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddPurchaseOrder", sender: nil)

    }
    
}
extension StockSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stock.purchaseOrder.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HoldingsTableViewCell
        cell.shareQuantityLabel.text = "\(stock.purchaseOrder[indexPath.row])"
        cell.purchasePriceLabel.text = "\(stock.purchasePrice[indexPath.row])"
        return cell
    }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
    }
}


