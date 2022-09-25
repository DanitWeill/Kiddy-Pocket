//
//  DeleteDataVC.swift
//  Pocket Money
//
//  Created by Danit on 04/07/2022.
//

import UIKit
import Firebase


class DeleteDataVC: UIViewController {
    
    
    @IBOutlet weak var warningPic: UIImageView!
    
    //  var nameToPass = String()
    var name = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningPic.image = UIImage(systemName: "exclamationmark.triangle")
        
        
    }
    
    
    
    @IBAction func yesButton(_ sender: UIButton) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("families").document(uid).collection("kids").getDocuments { querySnapshot, error in
            if let error = error{
                print("error")
            }
                if querySnapshot?.isEmpty == false {
                    
                    for names in querySnapshot!.documents {
                        names.reference.delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                                print("========================")
                                
                                self.showToast(message: "Data was deleted!", font: .systemFont(ofSize: 15.0))
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                                    self.performSegue(withIdentifier: "GoToHome", sender: self)
                                }
                            }
                        }
                    }
                } else {
                    self.showToast(message: "Data was deleted!", font: .systemFont(ofSize: 15.0))
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                        self.performSegue(withIdentifier: "GoToHome", sender: self)
                    }
            }
        }
    }
    
    @IBAction func noButton(_ sender: UIButton) {
        
        showToast(message: "Data was NOT deleted", font: .systemFont(ofSize: 15.0))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true)
        }
        
    }
}


extension DeleteDataVC {
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
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
