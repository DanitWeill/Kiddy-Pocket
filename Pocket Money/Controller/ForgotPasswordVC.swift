//
//  ForgotPasswordVC.swift
//  Pocket Money
//
//  Created by Danit on 14/09/2022.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        }
    

    @IBAction func sentButtonPressed(_ sender: UIButton) {
        let auth = Auth.auth()
        if emailTextField.text != ""{
            auth.sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let alert = UIAlertController(title: "", message: "Password reset email has been sent", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Thank You!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
                
        }
        
        }
    }
}
