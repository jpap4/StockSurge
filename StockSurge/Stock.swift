//
//  Stock.swift
//  StockSurge
//
//  Created by John Pappas on 12/15/20.
//  Copyright © 2020 John Pappas. All rights reserved.
//

import Foundation
import Firebase

class Stock: Codable {
    private struct Returned: Codable {
        var results: [StockRec]!
    }
    
    var symbol = ""
    var currentPrice = 0.0
    var dayHigh = 0.0
    var dayLow = 0.0
    var dayOpen = 0.0
    var dayChange = 0.0
    var sharesOwned = 0.0
    var currentValue = 0.0
    var totalReturn = 0.0
    var currentDate = Date()
    var buyrec = 0
    var sellrec = 0
    var holdrec = 0
    var numShares = 0
    var resultArray: [StockRec]! = []
    var userID: String
    var documentID: String
    

    
    func getStockData(companySymbol: String, completed: @ escaping() -> ()) {
        let urlString = "https://finnhub.io/api/v1/quote?symbol=\(companySymbol)&token=bvbqbsv48v6rqg57g5t0"
        
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
                        if let dictionary = jsonObj as? NSDictionary {
                            DispatchQueue.main.async {
                            }
                            if let currentprice = dictionary.value(forKey: "c") {
                                self.currentPrice = currentprice as? Double ?? 0.0
                            }
                            if let high = dictionary.value(forKey: "h") {
                                self.dayHigh = high as? Double ?? 0.0
                            }
                            if let low = dictionary.value(forKey: "l") {
                                self.dayLow = low as? Double ?? 0.0
                            }
                            if let open = dictionary.value(forKey: "l") {
                                self.dayOpen = open as? Double ?? 0.0
                            }
                            self.dayChange = (self.currentPrice/self.dayOpen - 1) * 100
                            self.symbol = companySymbol
                        } else {
                            print("Error")
                            return
                        }
                        completed()
                    }}}}
        task.resume()
    }
    func getStockRec(companySymbol: String, completed: @ escaping() -> ()) {
        let urlStringTwo = "https://finnhub.io/api/v1/stock/recommendation?symbol=\(companySymbol)&token=bvbqbsv48v6rqg57g5t0"
            guard let url = URL(string: urlStringTwo) else {
                print("Error")
                return
            }
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                do {
                    let returned = try JSONDecoder().decode([StockRec].self, from: data!)
                    self.resultArray = [returned[0]]
                    self.buyrec = returned[0].buy
                    self.holdrec = returned[0].hold
                    self.sellrec = returned[0].sell
                } catch {
                    return
                }
                completed()
            }
            task.resume()
        }
    private func saveData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("not a valid user id")
            return completion(false)
        }
        self.userID = currentUserID
        let dataToSave = ["Company Symbol": symbol, "Current Price": self.currentPrice, "Day Open": dayOpen, "Day Change": dayChange, "Number of Shares Owned": numShares] as [String : Any]
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
}
        
extension Collection where Indices.Iterator.Element == Index {
   public subscript(safe index: Index) -> Iterator.Element? {
     return (startIndex <= index && index < endIndex) ? self[index] : nil
   }
}
    
