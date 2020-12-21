//
//  Stocks.swift
//  StockSurge
//
//  Created by John Pappas on 12/15/20.
//  Copyright © 2020 John Pappas. All rights reserved.
//

import Foundation
import Firebase

class Stocks {
    var stockArray: [Stock] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore() 
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("stocks").whereField("UserID", isEqualTo: Auth.auth().currentUser?.uid ?? "").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error adding snapshotlistener")
                return completed()
            }
            self.stockArray = []
            for document in querySnapshot!.documents {
                let stock = Stock(dictionary: document.data())
                stock.documentID = document.documentID
                self.stockArray.append(stock)
            }
            completed()
        }
    }
}
