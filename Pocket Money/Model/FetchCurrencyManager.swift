//
//  FetchCurrencyManager.swift
//  Pocket Money
//
//  Created by Danit on 06/05/2022.
//

import Foundation

class FetchCurrencyManager {
    let baseCoinURL = "https://rest.coinapi.io/v1/exchangerate/EUR"
    let apiKey = "75EF3C24-E5DB-4CCC-BA28-47B9DC49B408"
    var rateToPass = Float()
    
    func fetchCoin(currencyName: String, completion: @escaping (Float) -> Void) {
        
        let urlString = "\(baseCoinURL)/\(currencyName)?apikey=\(apiKey)"
        performRequest(coinString: urlString)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1 ) {
            
            if self.rateToPass != 0.0 || self.rateToPass != nil {
                completion(self.rateToPass)
            }else{
                completion(1.0)
            }
        }
        
    }
    
    
    
    func performRequest(coinString: String){
        //create url
        if let url = URL(string: coinString){
            
            //create url session
            let session = URLSession(configuration: .default)
            
            //give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data{
                    self.parseJSON(coinData: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(coinData: Data){
        let decoder = JSONDecoder()
        do{
        let decodedData = try decoder.decode(CurrencyData.self, from: coinData)
            rateToPass = decodedData.rate
        }catch{
            print(error)
        }
    }
}
