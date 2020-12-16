//
//  StockSearchViewController.swift
//  StockSurge
//
//  Created by John Pappas on 12/15/20.
//  Copyright © 2020 John Pappas. All rights reserved.
//

import UIKit

class StockSearchViewController: UIViewController {
    
    @IBOutlet weak var searchView: UISearchBar!
    
    var stock = Stock()

            
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStockQuote" {
            let destination = segue.destination as! StockQuoteViewController
            destination.symbol = self.searchView.text!
        }
    }
    
    @IBAction func getQuotePressed(_ sender: UIButton) {
        self.stock.getStockData(companySymbol: self.searchView.text ?? "") {
            DispatchQueue.main.async {
            }
        }
    }
    
    @IBAction func getInstructionsPressed(_ sender: UIButton) {
    }
}

