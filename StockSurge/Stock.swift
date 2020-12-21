//
//  Stock.swift
//  StockSurge
//
//  Created by John Pappas on 12/15/20.
//  Copyright © 2020 John Pappas. All rights reserved.
//

import Foundation
import Firebase

class Stock: NSObject, Codable {
    var symbol: String
    var currentPrice: Double
    var dayOpen: Double
    var dayHigh: Double
    var dayLow: Double
    var dayChange: Double
    var fundsInvested: Double
    var sharesOwned: Double
    var currentValue: Double
    var totalGainLoss: Double
    var userID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["Symbol": symbol, "CurrentPrice": currentPrice, "DayOpen": dayOpen, "DayHigh": dayHigh, "DayLow": dayLow, "DayChange": dayChange, "FundsInvested": fundsInvested, "SharesOwned": sharesOwned, "CurrentValue": currentValue, "TotalGainLoss": totalGainLoss, "UserID": userID, "DocumentID": documentID]
    }
    
    init(symbol: String, currentPrice: Double, dayOpen: Double, dayHigh: Double, dayLow: Double, dayChange: Double, fundsInvested: Double, sharesOwned: Double, currentValue: Double, totalGainLoss: Double, userID: String, documentID: String) {
        self.symbol = symbol
        self.currentPrice = currentPrice
        self.dayOpen = dayOpen
        self.dayHigh = dayHigh
        self.dayLow = dayLow
        self.dayChange = dayChange
        self.fundsInvested = fundsInvested
        self.sharesOwned = sharesOwned
        self.currentValue = currentValue
        self.totalGainLoss = totalGainLoss
        self.userID = userID
        self.documentID = documentID
    }
    
    convenience override init() {
        self.init(symbol: "", currentPrice: 0.0, dayOpen: 0.0, dayHigh: 0.0, dayLow: 0.0, dayChange: 0.0, fundsInvested: 0.0, sharesOwned: 0.0, currentValue: 0.0, totalGainLoss: 0.0, userID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let symbol = dictionary["Symbol"] as! String? ?? ""
        let currentPrice = dictionary["CurrentPrice"] as! Double? ?? 0.0
        let dayOpen = dictionary["DayOpen"] as! Double? ?? 0.0
        let dayHigh = dictionary["DayHigh"] as! Double? ?? 0.0
        let dayLow = dictionary["DayLow"] as! Double? ?? 0.0
        let dayChange = dictionary["DayChange"] as! Double? ?? 0.0
        let fundsInvested = dictionary["FundsInvested"] as! Double? ?? 0.0
        let sharesOwned = dictionary["SharesOwned"] as! Double? ?? 0.0
        let currentValue = dictionary["CurrentValue"] as! Double? ?? 0.0
        let totalGainLoss = dictionary["TotalGainLoss"] as! Double? ?? 0.0
        let userID = dictionary["UserID"] as! String? ?? ""
        self.init(symbol: symbol, currentPrice: currentPrice, dayOpen: dayOpen, dayHigh: dayHigh, dayLow: dayLow, dayChange: dayChange, fundsInvested: fundsInvested, sharesOwned: sharesOwned, currentValue: currentValue, totalGainLoss: totalGainLoss, userID: userID, documentID: "")
    }
    
    func getStockData(ticker: String, completed: @ escaping() -> ()) {
        let urlString = "https://finnhub.io/api/v1/quote?symbol=\(ticker)&token=bvbqbsv48v6rqg57g5t0"
        
        guard let url = URL(string: urlString) else {
            print("Error: could not create a URL from \(urlString).")
            return
        }
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error)  in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            } else {
                if let data = data {
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                        if let dictionaryD = jsonObj as? NSDictionary {
                            DispatchQueue.main.async {
                            }
                            if let currentprice = dictionaryD.value(forKey: "c") {
                                self.currentPrice = currentprice as? Double ?? 0.0
                            }
                            if let high = dictionaryD.value(forKey: "h") {
                                self.dayHigh = high as? Double ?? 0.0
                                
                            }
                            if let low = dictionaryD.value(forKey: "l") {
                                self.dayLow = low as? Double ?? 0.0
                                
                            }
                            if let open = dictionaryD.value(forKey: "o") {
                                self.dayOpen = open as? Double ?? 0.0
                                
                            }
                            self.symbol = ticker
                        } else {
                            print("Error")
                            return
                        }
                        completed()
                    }}}}
        task.resume()
    }
    func saveData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            print("not a valid user id")
            return completion(false)
        }
        self.userID = userID
        let dataToSave: [String: Any] = self.dictionary
        if self.documentID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection("stocks").addDocument(data: dataToSave) {(error) in
                guard error == nil else {
                    print("ERROR")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("added document \(self.documentID)")
                completion(true)
            }
        } else {
            let ref = db.collection("stocks").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    print("ERROR")
                    return completion(false)
                }
                print("updated document \(self.documentID)")
                completion(true)
            }
        }
    }
    func updatePrices(completed: @escaping() -> ()) {
        let db = Firestore.firestore()
        db.collection("stocks").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
            print("Errorf")
            return completed()
            }
            for document in querySnapshot!.documents {
                let stockDictionary = document.data()
                let symbol2 = stockDictionary["Symbol"] as! String? ?? ""
                let currentPrice2 = stockDictionary["CurrentPrice"] as! Double? ?? 0.0
                let dayOpen2 = stockDictionary["DayOpen"] as! Double? ?? 0.0
                let dayHigh2 = stockDictionary["DayHigh"] as! Double? ?? 0.0
                let dayLow2 = stockDictionary["DayLow"] as! Double? ?? 0.0
                self.getStockData(ticker: symbol2) {
                    self.symbol = symbol2
                    self.currentPrice = currentPrice2
                    self.currentValue = self.currentPrice * self.sharesOwned
                    self.dayOpen = dayOpen2
                    self.dayHigh = dayHigh2
                    self.dayLow = dayLow2
                }
                let dataToSave = self.dictionary
                let stockRef = db.collection("stocks").document(self.documentID)
                stockRef.updateData(dataToSave) { (error) in
                    if error != nil {
                        print("Errorf")
                        completed()
                    } else {
                        print("goodf")
                        completed()
                    }
                }
            }
        }
    }
}



