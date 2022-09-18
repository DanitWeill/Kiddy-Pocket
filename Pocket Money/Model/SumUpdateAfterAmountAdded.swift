//
//  SumUpdateAfterAmountAdded.swift
//  Pocket Money
//
//  Created by Danit on 29/06/2022.
//

import Foundation
import Firebase

class SumUpdateAfterAmountAdded{
    
    let date = Date()
    var finalSum = Float()
    
    func sumUpdateAfterAmountAdded(amountAdded:Float, uid:String, kidName: String, completion: @escaping (Float) -> Void) {
                
        Firestore.firestore().collection("families").document(uid).collection("kids").document(kidName).getDocument { docs, error in
            if let error = error{
                print(error.localizedDescription)
            }
          
                Firestore.firestore().collection("families").document(uid).collection("kids").document(kidName).setData([
                    "date_to_begin" : self.date.timeIntervalSince1970], merge: true)
                
                
                
                //read from db and transaction
                
                let sumReference = Firestore.firestore().collection("families").document(uid).collection("kids").document(kidName)
                Firestore.firestore().runTransaction({ (transaction, errorPointer) -> Any? in
                    let sfDocument: DocumentSnapshot
                    do {
                        try sfDocument = transaction.getDocument(sumReference)
                    } catch let fetchError as NSError {
                        errorPointer?.pointee = fetchError
                        return nil
                    }
                    
                    guard let oldSum = sfDocument.data()?["sum"] as? Float else {
                        let error = NSError(
                            domain: "AppErrorDomain",
                            code: -1,
                            userInfo: [
                                NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
                            ]
                        )
                        errorPointer?.pointee = error
                        return nil
                    }
                    
                    //update sum in db
                    
                    transaction.updateData(["sum": oldSum + amountAdded], forDocument: sumReference)
                    self.finalSum = oldSum + amountAdded
                    return nil
                }) { (object, error) in
                    if let error = error {
                        print("Transaction failed: \(error)")
                        completion(self.finalSum)
                    } else {
                        print("Transaction successfully committed!")
                        completion(self.finalSum)
                      
                    }
                }
            
        }
        
       
     
    }
    
}
