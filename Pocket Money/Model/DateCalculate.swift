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
    
    func dateCalculate(constantAmountToAdd: Int, addEvery: Int, dateToBegin: TimeInterval, completion: @escaping (Int) -> Void) {
        
        
        let uid = Auth.auth().currentUser?.uid
      
        // Calculate how often to add money
        let now = self.date.timeIntervalSince1970
        
        if addEvery == 0 || constantAmountToAdd == 0{
            self.finalAmountOfMoneyToAdd = 0
            
        } else if now <= dateToBegin {
            self.finalAmountOfMoneyToAdd = 0
            
        } else if now > dateToBegin {
            
            let distance = Int((now - dateToBegin) / 86400)
            
            if distance >= addEvery{
                
                var numOfAdds = 0
                
                if distance == 0{
                    numOfAdds = 0
                }else{
                    numOfAdds = Int(distance / addEvery)
                }
               
                
                self.finalAmountOfMoneyToAdd = numOfAdds * constantAmountToAdd
        
            }
        }
        completion(finalAmountOfMoneyToAdd)
    }
}
        

