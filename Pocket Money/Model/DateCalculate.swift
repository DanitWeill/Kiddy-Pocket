//
//  DateCalculate.swift
//  Pocket Money
//
//  Created by Danit on 10/03/2022.
//

import Foundation
import Firebase


class DateCalculate{
    
    let db = Firestore.firestore()
    
    let date = Date()
    var timesToAdd = 0
    var finalAmountOfMoneyToAdd = 0
    
    
    // Calculate how often to add money

    func dateCalculate(nameToPass: String, currency: String, constantAmountToAdd: Int, addEvery: Int, dateToBegin: TimeInterval, completion: @escaping (Int) -> Void) {
        
        let uid = Auth.auth().currentUser?.uid ?? ""
        var distance = Int()
        var constantHistoryDateArray: [ConstantHistoryDateArray] = []
        
        
        let now = self.date.timeIntervalSince1970

        if addEvery == 0 || constantAmountToAdd == 0 {  // if user has NOT set constant time and amount to add

            self.finalAmountOfMoneyToAdd = 0
            
        } else if now <= dateToBegin { // If date to start has NOT passed
            self.finalAmountOfMoneyToAdd = 0
            
        } else if now >= (dateToBegin) + TimeInterval(86400 * (addEvery)) {
            // If date to start + addevery has passed- check the distance
            
            distance = Int((now - dateToBegin) / 86400)
            
            var numOfAdds = 0
            
            if distance == 0{ // if it is still the dateToBegin- don't add
                numOfAdds = 0
            }else{  // check how many times to add
                numOfAdds = Int(distance / addEvery)
            }
            
            self.finalAmountOfMoneyToAdd = numOfAdds * constantAmountToAdd
            
            
            // check how many times to add so it will be writen in the database.
            if addEvery != 0 {
                let howManyAddEvery = Int(distance / addEvery)
                
                if howManyAddEvery > 0 {
                    
                    for i in 1...howManyAddEvery{
                        
                        let dateToWrite =  TimeInterval(Int(dateToBegin) + (i * addEvery * 86400))
                        let dateToWrite2 = NSDate(timeIntervalSince1970: dateToWrite)
                        
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.timeZone = .current
                        formatter.locale = .current
                        formatter.dateFormat = "MMM d, yyyy"
                        var dateToWriteString = formatter.string(from: dateToWrite2 as Date)
                        
                        print("=================")
                        print(dateToWriteString)
                        
                        // add to database the date from start and the amount the user chose to add
                        self.db.collection("families").document(uid).collection("kids").document(nameToPass).collection("history").addDocument(data: [
                            "date money added": dateToWriteString,
                            "amount added": constantAmountToAdd,
                            "date": dateToWrite,
                            "currency": currency
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                        
                    }
                }
            }
        }
        
        
        completion(self.finalAmountOfMoneyToAdd)
        
        
    }
}

struct ConstantHistoryDateArray {
    let dateToWrite: String
    let constantAmountToAdd: Int
    let currency: String
}
