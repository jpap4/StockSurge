//
//  StockOrder.swift
//  StockSurge
//
//  Created by John Pappas on 12/19/20.
//  Copyright © 2020 John Pappas. All rights reserved.
//

import Foundation
import Firebase

class StockOrder {
    var sharesBought: Double
    var sharesSold: Double
    var purchasePrice: Double
    var fundsSpent: Double
    var fundsReceived: Double
    var reviewUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["SharesBought": sharesBought, "SharesSold": sharesSold, "PurchasePrice": purchasePrice, "FundsSpent": fundsSpent, "FundsReceived": fundsReceived, "ReviewUserID": reviewUserID]
    }
    
    init(sharesBought: Double, sharesSold: Double, purchasePrice: Double, fundsSpent: Double, fundsReceived: Double, reviewUserID: String, documentID: String) {
        self.sharesBought = sharesBought
        self.sharesSold = sharesSold
        self.purchasePrice = purchasePrice
        self.fundsSpent = fundsSpent
        self.fundsReceived = fundsReceived
        self.reviewUserID = reviewUserID
        self.documentID = documentID
    }
    
    convenience init() {
        let reviewUserID = Auth.auth().currentUser?.uid ?? ""
        self.init(sharesBought: 0.0, sharesSold: 0.0, purchasePrice: 0.0, fundsSpent: 0.0, fundsReceived: 0.0, reviewUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let sharesBought = dictionary["SharesBought"] as! Double? ?? 0.0
        let sharesSold = dictionary["SharesSold"] as! Double? ?? 0.0
        let purchasePrice = dictionary["PurchasePrice"] as! Double? ?? 0.0
        let fundsSpent = dictionary["FundsSpent"] as! Double? ?? 0.0
        let fundsReceived = dictionary["FundsReceived"] as! Double? ?? 0.0
        let reviewUserID = dictionary["reviewUserID"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        self.init(sharesBought: sharesBought, sharesSold: sharesSold, purchasePrice: purchasePrice, fundsSpent: fundsSpent, fundsReceived: fundsReceived, reviewUserID: reviewUserID, documentID: documentID)
    }
    
    func saveData(stock: Stock, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let dataToSave: [String: Any] = self.dictionary
        if self.documentID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection("stocks").document(stock.documentID).collection("orders").addDocument(data: dataToSave) {(error) in
                guard error == nil else {
                    print("ERROR")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("added document \(self.documentID) to spot: \(stock.documentID)")
//                spot.updateAverageRating {
//                    completion(true)
//                }
            }
        } else {
            let ref = db.collection("stocks").document(stock.documentID).collection("orders").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    print("ERROR")
                    return completion(false)
                }
                print("updated document \(self.documentID) in stock: \(stock.documentID)")
//                spot.updateAverageRating {
//                    completion(true)
//                }
            }
        }
    }
    
    func deleteData(stock: Stock, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("stocks").document(stock.documentID).collection("orders").document(documentID).delete { (error) in
            if error != nil {
                print("error")
                completion(false)
            } else {
                print("document deleted")
//                spot.updateAverageRating {
//                    completion(true)
//                }
            }
        }
    }
}

