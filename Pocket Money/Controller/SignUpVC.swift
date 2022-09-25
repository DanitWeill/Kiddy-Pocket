//
//  SignUpVC.swift
//  Pocket Money
//
//  Created by Danit on 01/02/2022.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
    }
    
    @objc func tap(sender: UITapGestureRecognizer){
        print("tapped")
        view.endEditing(true)
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        if let email = usernameTextField.text, let password = passwordTextField.text {
            if email != "" && password != "" {
                //check if user is anonymos- if anonymous (convert to user), if not anonymous ( sign up)
                
                let user = Auth.auth().currentUser
                if user?.isAnonymous == true {
                    let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                    user?.link(with: credential) { authResult, error in
                        if let error = error {
                            print(error.localizedDescription)
                            self.errorLabel.text = "\(error.localizedDescription)"
                        }
                    }
                    
                } else {
                    
                    // if user is not anonymous- new user
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        
                        if error?.localizedDescription != nil {
                            print("user is alreadey exist=======")
                            print(error?.localizedDescription)
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = error!.localizedDescription
                            // "A user with this email already exists"
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3 ) {
                                self.errorLabel.isHidden = true
                                
                            }
                        }
                        if let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as? MainVC {
                            let navVC = UINavigationController(rootViewController: mainVC)
                            navVC.modalPresentationStyle = .fullScreen

                            self.present(navVC, animated: true, completion: nil)
                            
                            
                        }
                        
                    }
                }
            }
        } else {
            errorLabel.isHidden = false
            errorLabel.text = "Please enter email and password"
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3 ) {
                self.errorLabel.isHidden = true
                
            }
        }
    }
    
}
