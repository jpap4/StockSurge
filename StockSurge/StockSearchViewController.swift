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
    
    var stock = Stock() 
    var authUI: FUIAuth!


            
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI.delegate = self

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
