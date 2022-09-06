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
    
    func sumUpdateAfterAmountAdded(oldSum:Float, amountAdded:Float, uid:String, kidName: String){
                
        Firestore.firestore().collection("families").document(uid).collection("kids").document(kidName).setData([
            "sum" : oldSum + amountAdded,
            "date_to_begin" : date.timeIntervalSince1970], merge: true)
    
        
    }
    
}
