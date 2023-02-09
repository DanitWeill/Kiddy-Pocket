//
//  AddByTimeVC.swift
//  Pocket Money
//
//  Created by Danit on 22/02/2022.
//

import UIKit
import Firebase

class AddByTimeVC: UIViewController {
    
    
    
    @IBOutlet weak var constantAmountToAddTextfield: UITextField!
    @IBOutlet weak var swicher: UISwitch!
    
    @IBOutlet weak var swicherLabel: UILabel!
    
    @IBOutlet weak var sunButton: UIButton!
    @IBOutlet weak var monButton: UIButton!
    @IBOutlet weak var tueButton: UIButton!
    @IBOutlet weak var wedButton: UIButton!
    @IBOutlet weak var thuButton: UIButton!
    @IBOutlet weak var friButton: UIButton!
    @IBOutlet weak var satButton: UIButton!
    
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    
    
    
    
    let db = Firestore.firestore()
    var dateToBeginString = String()
    var dateToBeginDate = Date()
    var addEvery = 0
    var finalAmountToAdd = 0
    
    var nameToPass: String = ""
    var currentWeekday: Int = 1
    var daysToAdd = 0
    var weekDayToBegin = Int()
    var swicherOnOff = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let date = Date()
        let calendar = Calendar.current
        currentWeekday = calendar.component(.weekday, from: date)

        // upload the data the user determined- read from db
        guard let uid = Auth.auth().currentUser?.uid else {return}
        db.collection("families").document(uid).collection("kids").document(nameToPass).getDocument(completion: { doc, error in
            if let error = error{
                print(error)
            }


            let constantAmountToAdd = doc?["constant_amount_to_add"] as? Int ?? 0
            let addEvery = doc?.data()?["add_every"] as? Int ?? 0
            let weekDayToBegin = doc?.data()?["week_day_to_begin"] as? Int ?? 0
            self.swicherOnOff = doc?.data()?["swicherOnOff"] as? Bool ?? false

            self.constantAmountToAddTextfield.text = String(constantAmountToAdd)
            
            if addEvery == 0 {
                self.dayButton.isSelected = false
                self.weekButton.isSelected = false
                self.monthButton.isSelected = false
           } else if addEvery == 1 {
                self.dayButton.isSelected = true
                self.addEvery = 1
            } else if addEvery == 7 {
                self.weekButton.isSelected = true
                self.addEvery = 7
            } else if addEvery == 30 {
                self.monthButton.isSelected = true
                self.addEvery = 30
            }
            
            if weekDayToBegin == 0 {
                self.sunButton.isSelected = false
                self.monButton.isSelected = false
                self.tueButton.isSelected = false
                self.wedButton.isSelected = false
                self.thuButton.isSelected = false
                self.friButton.isSelected = false
                self.satButton.isSelected = false
            } else if weekDayToBegin == 1 {
                self.sunButton.isSelected = true
                self.weekDayToBegin = 1
            } else if weekDayToBegin == 2 {
                self.monButton.isSelected = true
                self.weekDayToBegin = 2
            } else if weekDayToBegin == 3 {
                self.tueButton.isSelected = true
                self.weekDayToBegin = 3
            } else if weekDayToBegin == 4 {
                self.wedButton.isSelected = true
                self.weekDayToBegin = 4
            } else if weekDayToBegin == 5 {
                self.thuButton.isSelected = true
                self.weekDayToBegin = 5
            } else if weekDayToBegin == 6 {
                self.friButton.isSelected = true
                self.weekDayToBegin = 6
            } else if weekDayToBegin == 7 {
                self.satButton.isSelected = true
                self.weekDayToBegin = 7
            }
            
            if self.swicherOnOff == true {
                self.swicher.isOn = true
                self.swicherLabel.text = "Active"

            }else{
                self.swicher.isOn = false
                self.swicherLabel.text = "Not Active"

            }
        })
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
      
    }
    
    @objc func tap(sender: UITapGestureRecognizer){
        print("tapped")
        view.endEditing(true)
    }
  
    
    @IBAction func sunButton(_ sender: UIButton) {
        if sunButton.isSelected == false {
            sunButton.isSelected = true
            sunButton.backgroundColor = UIColor.gray
            
            monButton.isSelected = false
            monButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            tueButton.isSelected = false
            tueButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            wedButton.isSelected = false
            wedButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            thuButton.isSelected = false
            thuButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            friButton.isSelected = false
            friButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            satButton.isSelected = false
            satButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            
            weekDayToBegin = 1
            if currentWeekday > 1 {
                daysToAdd = (7 - currentWeekday) + 1
            }else if currentWeekday < 1{
                daysToAdd = 1 - currentWeekday
            }else{
                daysToAdd = 0
            }
        }
    }
    
    @IBAction func monButton(_ sender: UIButton) {
        if monButton.isSelected == false {
            monButton.isSelected = true
            monButton.backgroundColor = UIColor.gray
            
            sunButton.isSelected = false
            sunButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            tueButton.isSelected = false
            tueButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            wedButton.isSelected = false
            wedButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            thuButton.isSelected = false
            thuButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            friButton.isSelected = false
            friButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            satButton.isSelected = false
            satButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            
            weekDayToBegin = 2

            if currentWeekday > 2 {
                daysToAdd = (7 - currentWeekday) + 2
            }else if currentWeekday < 2{
                daysToAdd = 2 - currentWeekday
            }else{
                daysToAdd = 0
            }
        }
    }
    
    @IBAction func tueButton(_ sender: UIButton) {
        if tueButton.isSelected == false {
            tueButton.isSelected = true
            tueButton.backgroundColor = UIColor.gray
            sunButton.isSelected = false
            sunButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            monButton.isSelected = false
            monButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            wedButton.isSelected = false
            wedButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            thuButton.isSelected = false
            thuButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            friButton.isSelected = false
            friButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            satButton.isSelected = false
            satButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            
            weekDayToBegin = 3

            if currentWeekday > 3 {
                daysToAdd = (7 - currentWeekday) + 3
            }else if currentWeekday < 3{
                daysToAdd = 3 - currentWeekday
            }else{
                daysToAdd = 0
            }
        }
    }
    
    @IBAction func wedButton(_ sender: UIButton) {
        if wedButton.isSelected == false {
            wedButton.isSelected = true
            wedButton.backgroundColor = UIColor.gray
            sunButton.isSelected = false
            sunButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            monButton.isSelected = false
            monButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            tueButton.isSelected = false
            tueButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            thuButton.isSelected = false
            thuButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            friButton.isSelected = false
            friButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            satButton.isSelected = false
            satButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            
            weekDayToBegin = 4

            if currentWeekday > 4 {
                daysToAdd = (7 - currentWeekday) + 4
            }else if currentWeekday < 4{
                daysToAdd = 4 - currentWeekday
            }else{
                daysToAdd = 0
            }
        }
    }
    
    @IBAction func thuButton(_ sender: UIButton) {
        if thuButton.isSelected == false {
            thuButton.isSelected = true
            thuButton.backgroundColor = UIColor.gray
            sunButton.isSelected = false
            sunButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            monButton.isSelected = false
            monButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            tueButton.isSelected = false
            tueButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            wedButton.isSelected = false
            wedButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            friButton.isSelected = false
            friButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            satButton.isSelected = false
            satButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            
            weekDayToBegin = 5

            if currentWeekday > 5 {
                daysToAdd = (7 - currentWeekday) + 5
            }else if currentWeekday < 5{
                daysToAdd = 5 - currentWeekday
            }else{
                daysToAdd = 0
            }
        }
    }
    
    @IBAction func friButton(_ sender: UIButton) {
        if friButton.isSelected == false {
            friButton.isSelected = true
            friButton.backgroundColor = UIColor.gray
            sunButton.isSelected = false
            sunButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            monButton.isSelected = false
            monButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            tueButton.isSelected = false
            tueButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            wedButton.isSelected = false
            wedButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            thuButton.isSelected = false
            thuButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            satButton.isSelected = false
            satButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            
            weekDayToBegin = 6

            if currentWeekday > 6 {
                daysToAdd = (7 - currentWeekday) + 6
            }else if currentWeekday < 6{
                daysToAdd = 6 - currentWeekday
            }else{
                daysToAdd = 0
            }
        }
    }
    
    @IBAction func satButton(_ sender: UIButton) {
        if satButton.isSelected == false {
            satButton.isSelected = true
            satButton.backgroundColor = UIColor.gray
            sunButton.isSelected = false
            sunButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            monButton.isSelected = false
            monButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            tueButton.isSelected = false
            tueButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            wedButton.isSelected = false
            wedButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            thuButton.isSelected = false
            thuButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            friButton.isSelected = false
            friButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            
            weekDayToBegin = 7

            if currentWeekday > 7 {
                daysToAdd = (7 - currentWeekday) + 7
            }else if currentWeekday < 7{
                daysToAdd = 7 - currentWeekday
            }else{
                daysToAdd = 0
            }
            
        }
    }
    
    
    @IBAction func dayButton(_ sender: UIButton) {
        if dayButton.isSelected == false {
            dayButton.isSelected = true
            dayButton.backgroundColor = UIColor.gray
            
            weekButton.isSelected = false
            weekButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            monthButton.isSelected = false
            monthButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            
            addEvery = 1
        }
    }
    
    @IBAction func weekButton(_ sender: UIButton) {
        if weekButton.isSelected == false {
            weekButton.isSelected = true
            weekButton.backgroundColor = UIColor.gray
            dayButton.isSelected = false
            dayButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            monthButton.isSelected = false
            monthButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)

            addEvery = 7
            
        }
    }
    
    @IBAction func monthButton(_ sender: UIButton) {
        if monthButton.isSelected == false {
            monthButton.isSelected = true
            monthButton.backgroundColor = UIColor.gray
            dayButton.isSelected = false
            dayButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            weekButton.isSelected = false
            weekButton.backgroundColor = #colorLiteral(red: 1, green: 0.656021297, blue: 0.1703382134, alpha: 1)
            
            addEvery = 30
            
        }
    }
    
    
    @IBAction func swicher(_ sender: UISwitch) {
        if sender.isOn{
            swicherOnOff = true
            swicherLabel.text = "Active"
            if weekDayToBegin == 0 {
                showToast(message: "Please choose day to start adding", font: .systemFont(ofSize: 12.0))
                swicher.isOn = false
            }
            if addEvery == 0 {
                showToast(message: "Please choose how often to add", font: .systemFont(ofSize: 12.0))
                swicher.isOn = false
            }
            if constantAmountToAddTextfield.text == "" || constantAmountToAddTextfield.text == "0" {
                //if amount is empty
                showToast(message: "Please fill amount", font: .systemFont(ofSize: 12.0))
                swicher.isOn = false
            }
        }else{
            //if swicher is off
            swicherOnOff = false
            swicherLabel.text = "Not Active"

            
        }
    }
    
    @IBAction func saveChangesButtonPressed(_ sender: UIButton) {
        if swicherOnOff == true {

                guard let uid = Auth.auth().currentUser?.uid else {return}
                let date = Date()
                
                db.collection("families").document(uid).collection("kids").document(nameToPass).updateData([
                    "constant_amount_to_add": Int(constantAmountToAddTextfield.text ?? ""),
                    "date_to_begin": date.timeIntervalSince1970 + TimeInterval(daysToAdd * 86400),
                    "add_every": addEvery,
                    "week_day_to_begin": weekDayToBegin,
                    "swicherOnOff": swicherOnOff
                ]){ err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("setConstantAmountToAdd successfully written!")
                        print(self.constantAmountToAddTextfield.text)
                    }
                }
          
            
            showToast(message: "Saved!", font: .systemFont(ofSize: 12.0))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.dismiss(animated: true)
                }
        } else {
            // if swicher is off
                        
            guard let uid = Auth.auth().currentUser?.uid else {return}

            db.collection("families").document(uid).collection("kids").document(nameToPass).updateData([
                "constant_amount_to_add": "0",
                "date_to_begin": Date().timeIntervalSince1970,
                "add_every": "0"
            ]){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                    //what will happen if the name and sum are nil
                } else {
                    print("setConstantAmountToAdd successfully written!")
                    print(self.constantAmountToAddTextfield.text)
                }
            }
            showToast(message: "Not Saved", font: .systemFont(ofSize: 12.0))
            
            
        }
        
        print("tapped")
        view.endEditing(true)
     
        
    }
    
}



extension AddByTimeVC {
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.center = CGPoint(x: 160, y: 285)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
