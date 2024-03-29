//
//  UserDetailsVC.swift
//  Pocket Money
//
//  Created by Danit on 03/02/2022.
//

import UIKit
import Firebase

class UserDetailsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var kidPicture: UIImageView!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var addMoneyPicker: UIButton!
    
    let db = Firestore.firestore()
    
    var arrayOfDate: [String] = []
    var arrayOfAmount: [Int] = []
    var arrayOfCurrency: [String] = []
    var dateArray: [DateHistoryArray] = []
    var numOfCells = 0
    
    var kidsStringToPass: [Kid] = []
    var kidsIndex = 0
    var currencySumToPass = Float()
    var currencyNameToPass = String()
    var rateToPass = Float()
    
    
    
    let addMoneyVC = AddMoneyVC()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMoneyPicker.frame = CGRect(x: 160, y: 100, width: 70, height: 70)
        addMoneyPicker.layer.cornerRadius = 0.5 * addMoneyPicker.bounds.size.width
        addMoneyPicker.clipsToBounds = true
          view.addSubview(addMoneyPicker)
        
        kidPicture.clipsToBounds = true
        importData()
        
        nameLabel.text = kidsStringToPass[kidsIndex].name
        
        currencyNameLabel.text = currencyNameToPass
        
      
        
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserDetailsCell", bundle: nil), forCellReuseIdentifier: "UserDetailsCellIdentifier")
        
        NotificationCenter.default.addObserver(self, selector: #selector(sumUpdateRecived), name: Notification.Name("sumUpdate"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(dateRecived), name: Notification.Name("dateUpdate"), object: nil)
        
        
    }
    
  
    
    func importData(){
        guard let uid = Auth.auth().currentUser?.uid else {return}

        db.collection("families").document(uid).collection("kids").document(kidsStringToPass[kidsIndex].name).getDocument { doc, err in
            if let err = err{
                print(err.localizedDescription)
            }else{
                
                if doc?.data()?["sum"] != nil{
                    if let data = doc?.data()?["sum"] as? Float{
                        let sum = (data) * self.rateToPass
                        self.sumLabel.text = String(format: "%.2f", sum)
                    } else {
                        print ("error loading sum in user details vc- check there")
                        print ("XXXXXXXXXXXXXXXXXX")

                    }
                }
                
            }
        }
        
        db.collection("families").document(uid).collection("kids").document(kidsStringToPass[kidsIndex].name).getDocument { doc, error in
            if let error = error{
                print(error.localizedDescription)
            }else{
                let userPicRef = doc?.data()?["pictureURL"] as? String
                if userPicRef != "" {
                let storage = Storage.storage().reference(forURL: userPicRef!)
                storage.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    if let error = error {
                        self.kidPicture.image = UIImage(named: "userIcon")!
                        print(error.localizedDescription)
                    } else {
                        self.kidPicture.image = UIImage(data: data!)!
                        }
                    }
                } else {
                    self.kidPicture.image = UIImage(named: "userIcon")!
                }
            }
        }
        
        db.collection("families").document(uid).collection("kids").document(kidsStringToPass[kidsIndex].name).collection("history").order(by: "date").getDocuments { docs, err in
            if let e = err{
                print(e)
            } else {
                
                self.arrayOfDate = []
                self.arrayOfAmount = []
                self.arrayOfCurrency = []
                
                if docs?.count ?? 0 > 0{
                    for i in 0...docs!.count-1{
                        
                        let date = docs?.documents[i]["date money added"] as? String
                        let amount = docs?.documents[i]["amount added"] as? Int
                        let currency = docs?.documents[i]["currency"] as? String
                        
                        self.arrayOfDate.append(date ?? "")
                        self.arrayOfAmount.append(amount ?? 0)
                        self.arrayOfCurrency.append(currency ?? "")

                        
                    }
                }
                self.arrayOfDate.reverse()
                self.arrayOfAmount.reverse()
                self.arrayOfCurrency.reverse()

                
                self.tableView.reloadData()
                
               
            }
        }
    }
    
    @objc func sumUpdateRecived(){
        importData()
    }
    

    
    @objc func dateRecived(){
        importData()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let popUpButtonsVC = segue.destination as? PopUpButtonsVC {
            popUpButtonsVC.nameToPass = nameLabel.text!
            popUpButtonsVC.rateToPass = rateToPass
            
        }
    }
}



extension UserDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailsCellIdentifier", for: indexPath) as! UserDetailsCell
        
        cell.backgroundColor = UIColor(#colorLiteral(red: 1, green: 0.8856521249, blue: 0.1325125396, alpha: 1))
        
        cell.dateLabel.text = arrayOfDate[indexPath.row]
        cell.amountAddedLabel.text = String(arrayOfAmount[indexPath.row])
        cell.currencyLabel.text = arrayOfCurrency[indexPath.row]
        
        return cell
    }
    
}
