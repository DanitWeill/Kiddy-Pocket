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
    
    func dateCalculate(nameToPass: String, currency: String, constantAmountToAdd: Int, addEvery: Int, dateToBegin: TimeInterval, completion: @escaping (Int) -> Void) {
        
        let uid = Auth.auth().currentUser?.uid ?? ""
        var distance = Int()
        var constantDateArray: [ConstantDateArray] = []
        var dateToWriteString: String = ""
        
        // Calculate how often to add money
        let now = self.date.timeIntervalSince1970
        
        if addEvery == 0 || constantAmountToAdd == 0{
            self.finalAmountOfMoneyToAdd = 0
            
        } else if now <= dateToBegin {
            self.finalAmountOfMoneyToAdd = 0
            
        } else if now > dateToBegin {
            
            distance = Int((now - dateToBegin) / 86400)
            
            if distance >= addEvery{
                
                var numOfAdds = 0
                
                if distance == 0{
                    numOfAdds = 0
                }else{
                    numOfAdds = Int(distance / addEvery)
                }
                
                
                self.finalAmountOfMoneyToAdd = numOfAdds * constantAmountToAdd
                
            }
            // add to database the date from start and the amount the user chose to add
            
            
            
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

struct ConstantDateArray {
    let dateToWrite: String
    let constantAmountToAdd: Int
    let currency: String
}
