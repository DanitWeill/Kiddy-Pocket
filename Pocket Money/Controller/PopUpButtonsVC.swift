//
//  PopUpButtonsVC.swift
//  Pocket Money
//
//  Created by Danit on 02/05/2022.
//

import UIKit

class PopUpButtonsVC: UIViewController {

    @IBOutlet weak var addMoney: UIButton!
    @IBOutlet weak var addConstant: UIButton!
    @IBOutlet weak var subtractMoney: UIButton!
    
    var nameToPass: String = ""
    var rateToPass = Float()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 1, alpha: 0.0)


        
        addMoney.frame = CGRect(x: 160, y: 100, width: 70, height: 70)
        addMoney.layer.cornerRadius = 0.5 * addMoney.bounds.size.width
        addMoney.clipsToBounds = true
          view.addSubview(addMoney)
        
        addConstant.frame = CGRect(x: 160, y: 100, width: 70, height: 70)
        addConstant.layer.cornerRadius = 0.5 * addConstant.bounds.size.width
        addConstant.clipsToBounds = true
          view.addSubview(addConstant)
        
        subtractMoney.frame = CGRect(x: 160, y: 100, width: 70, height: 70)
        subtractMoney.layer.cornerRadius = 0.5 * addConstant.bounds.size.width
        subtractMoney.clipsToBounds = true
          view.addSubview(subtractMoney)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAnywhere)))

      }
        
    
    
    @IBAction func addMoney(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAddMoneyVC", sender: self)
    }
    
    
    @IBAction func addConstant(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAddByTimeVC", sender: self)
    }
    
    @IBAction func subtractMoney(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSubtract", sender: self)
    }
    

    @objc func tapAnywhere(sender: UITapGestureRecognizer){
        print("tapped")
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addMoneyVC = segue.destination as? AddMoneyVC {
            addMoneyVC.nameToPass = nameToPass
            addMoneyVC.rateToPass = rateToPass

        }
        if let addByTimeVC = segue.destination as? AddByTimeVC {
            addByTimeVC.nameToPass = nameToPass
        }
        if let subtractVC = segue.destination as? SubtractVC {
            subtractVC.nameToPass = nameToPass
            subtractVC.rateToPass = rateToPass
        }
    }
}
