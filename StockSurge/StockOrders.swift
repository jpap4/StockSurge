//
//  StockOrders.swift
//  StockSurge
//
//  Created by John Pappas on 12/19/20.
//  Copyright © 2020 John Pappas. All rights reserved.
//

import Foundation
import Firebase

class StockOrders {
    var orderArray: [StockOrder] = []
    
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(stock: Stock, completed: @escaping () -> ()) {
        guard stock.documentID != "" else {
            return
        }
        db.collection("stocks").document(stock.documentID).collection("orders").whereField("UserID", isEqualTo: Auth.auth().currentUser?.uid ?? "").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error adding snapshotlistener")
                return completed()
            }
            self.orderArray = []
            for document in querySnapshot!.documents {
                let order = StockOrder(dictionary: document.data())
                order.documentID = document.documentID
                self.orderArray.append(order)
            }
            completed()
        }
    }
}
