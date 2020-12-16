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
    @IBOutlet weak var buyRecLabel: UILabel!
    @IBOutlet weak var holdRecLabel: UILabel!
    @IBOutlet weak var sellRecLabel: UILabel!
    
    var stock = Stock()
    var authUI: FUIAuth!
    var symbol = ""
    var numberShares = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI.delegate = self
        currentPriceLabel.text = ""
        dayHighLabel.text = ""
        dayOpenLabel.text = ""
        dayHighLabel.text = ""
        dayLowLabel.text = ""
        percentChangeLabel.text = ""
        comSymbol.text = ""
        buyRecLabel.text = ""
        holdRecLabel.text = ""
        sellRecLabel.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "ShowPortfolio":
            let destination = segue.destination as! PortfolioViewController
            destination.stock = stock
        case "stocksearchbuystock":
            let destination = segue.destination as! BuyOrSellViewController
            destination.symbol = self.symbol
            destination.stock = stock
        default:
            print("Error")
        }
    }
    
    @IBAction func getQuotePressed(_ sender: UIButton) {
        self.symbol = searchView.text ?? ""
        print(symbol)
        stock.getStockData(companySymbol: searchView.text ?? "") {
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
                self.numberShares = 0
            }
        }
        self.stock.getStockRec(companySymbol: self.symbol) {
            DispatchQueue.main.async {
                self.buyRecLabel.text = "\(self.stock.resultArray[0].buy)"
                self.holdRecLabel.text = "\(self.stock.resultArray[0].hold)"
                self.sellRecLabel.text = "\(self.stock.resultArray[0].sell)"
                    }
                }
        if self.stock.resultArray .isEmpty {
            self.oneButtonAlert(title: "Error", message: "Invalid Search")
        } else { return }
            }
    
    func signOut () {
        do {
            try authUI!.signOut()
        } catch {
            print("😡 ERROR: couldn't sign out")
            performSegue(withIdentifier: "FirstShowSegue", sender: nil)
        }
    }

    @IBAction func unwindSignOutPressed(segue: UIStoryboardSegue) {
        if segue.identifier == "SignOutUnwind" {
            signOut()
        }
    }
    
    @IBAction func getInstructionsPressed(_ sender: UIButton) {
    }
    @IBAction func instructionsPressed(_ sender: UIButton) {
    }

    
}

extension StockSearchViewController: FUIAuthDelegate {
func application(_ app: UIApplication, open url: URL,
                 options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
    if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
        return true
    }
    return false
}

func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
    guard error == nil else {
        print("😡 ERROR: during signin \(error!.localizedDescription)")
        return
    }
    if let user = user {
        print("📝 We signed in with user \(user.email ?? "unknown e-mail")")
    }
}
}
