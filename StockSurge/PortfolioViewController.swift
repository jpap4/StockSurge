//
//  PortfolioViewController.swift
//  StockSurge
//
//  Created by John Pappas on 12/16/20.
//  Copyright © 2020 John Pappas. All rights reserved.
//

import UIKit

class PortfolioViewController: UIViewController {
    @IBOutlet weak var portfolioValueLabel: UILabel!
    @IBOutlet weak var portfolioTotalGainLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var stocks: Stocks!
    var stock: Stock!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
    }
    @IBAction func buyButtonPressed(_ sender: UIBarButtonItem) {
    }
    @IBAction func findStockPressed(_ sender: UIBarButtonItem) {
    }
    
}

extension PortfolioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.textLabel?.text = species.speciesArray[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}
