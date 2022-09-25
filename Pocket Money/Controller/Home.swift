//
//  Home.swift
//  Pocket Money
//
//  Created by Danit on 01/02/2022.
//

import UIKit
import Firebase

class Home: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func letsGetStarted(_ sender: UIButton) {
       
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                
                let errorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
                errorLabel.textAlignment = .center
                errorLabel.text = "\(error.localizedDescription)"

                self.view.addSubview(errorLabel)
                                     
            }
        
            if let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as? MainVC {

                let navVC = UINavigationController(rootViewController: mainVC)
                navVC.modalPresentationStyle = .fullScreen

                self.present(navVC, animated: true, completion: nil)
            }
            
        }
        
    }
}

