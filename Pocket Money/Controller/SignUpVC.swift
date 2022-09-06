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
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailError.isHidden = true
        passwordError.isHidden = true
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
    }
    
    @objc func tap(sender: UITapGestureRecognizer){
        print("tapped")
        view.endEditing(true)
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        if let email = usernameTextField.text, let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if error?.localizedDescription != nil {
                    print("user is alreadey exist=======")
                    print(error?.localizedDescription)
                    self.emailError.isHidden = false
                    self.emailError.text = error!.localizedDescription
                    // "A user with this email already exists"
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3 ) {
                        self.emailError.isHidden = true
                        
                    }
                }
            }
        }else{
            
            if let logInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC") as? LogInVC {
                let navVC = UINavigationController(rootViewController: logInVC)
                
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
}

//    }
//}

//extension SigninVC {
//
//    func showToast(message : String, font: UIFont) {
//
//        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
//        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        toastLabel.textColor = UIColor.white
//        toastLabel.font = font
//        toastLabel.center = CGPoint(x: 160, y: 285)
//        toastLabel.textAlignment = .center;
//        toastLabel.text = message
//        toastLabel.alpha = 1.0
//        toastLabel.layer.cornerRadius = 10;
//        toastLabel.clipsToBounds  =  true
//        self.view.addSubview(toastLabel)
//        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
//            toastLabel.alpha = 0.0
//        }, completion: {(isCompleted) in
//            toastLabel.removeFromSuperview()
//        })
//    } }
