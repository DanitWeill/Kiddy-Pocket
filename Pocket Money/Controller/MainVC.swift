//
//  MainVC.swift
//  Pocket Money
//
//  Created by Danit on 01/02/2022.
//

import UIKit
import Firebase
import SwipeCellKit


class MainVC: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addFirstKidLabel: UILabel!
    
    // benny
    
    var kids: [Kid] = []
    
    var name = String()
    //    var sum = Float()
    var currencyName = String()
    var cellColor = UIColor(hexString: "#ffffff")
    var kidImage = UIImage()
    
    var kidsIndex = Int()
    
    var rate = Float()
    var constantAmountToAdd = Int()
    var addEvery = Int()
    var dateToBegin = TimeInterval()
    var finalAmountToAdd = Float()
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuButton.menu = addMenuItems()
        addFirstKidLabel.isHidden = true
        
        
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil{
                
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home") as? Home
                {
                    self.present(vc, animated: true, completion: nil)
                }
                
            }else{
                
                self.updateDefaultCurreny()  //its needed for knowing the currency when adding a new kid
                
                self.tableView.delegate = self
                self.tableView.dataSource = self
                
                self.navigationItem.setHidesBackButton(true, animated: true)
                
                self.tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "userCellIdentifier")
                
                //update when new user added on AddUserVC
                NotificationCenter.default.addObserver(self, selector: #selector(self.updateRecived), name: Notification.Name("newUserUpdate"), object: nil)
                
                //update the sum that changed when money was added
                NotificationCenter.default.addObserver(self, selector: #selector(self.updateRecived), name: Notification.Name("sumUpdate"), object: nil)
                
                //update the currency label
                NotificationCenter.default.addObserver(self, selector: #selector(self.updateRecived), name: Notification.Name("currencyNameUpdate"), object: nil)
                
                
                self.loadKids()
                
            }
        })
    }
    
    
    @objc func updateRecived(){
        updateDefaultCurreny()
        loadKids()
        
    }
    
    func loadKids() {
        
        self.tableView.alpha = 0
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        //loading circle
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        self.kids = []
        
        self.db.collection("families").document(uid).getDocument { doc, error in
            if let err = error{
                print(err.localizedDescription)
            }else{
                
                let currency = doc?.data()?["currency"] ?? "ILS"
                
                self.currencyName = currency as! String
                
                FetchCurrencyManager().fetchCoin(currencyName: currency as! String) { rateRecived in
                    self.rate = rateRecived
                    
                    self.db.collection("families").document(uid).collection("kids").getDocuments { querySnapshot, error in
                        if let e = error {
                            print("Error getting documents: \(e)")
                            
                        } else {
                            
                            if let documents = querySnapshot?.documents {
                                
                                if documents.count == 0{
                                    self.activityIndicator.stopAnimating()
                                    UIApplication.shared.endIgnoringInteractionEvents()
                                    self.addFirstKidLabel.isHidden = false
                                }else{
                                    self.addFirstKidLabel.isHidden = true
                                    for document in documents {
                                        
                                        let data = document.data()
                                        
                                        self.constantAmountToAdd = data["constant_amount_to_add"] as? Int ?? 0
                                        self.addEvery = data["add_every"] as? Int ?? 0
                                        self.dateToBegin = data["date_to_begin"] as? TimeInterval ?? 0
                                        
                                        if let name = data["name"] as? String, var sum = data["sum"] as? Float  {
                                            
                                            DateCalculate().dateCalculate(constantAmountToAdd: self.constantAmountToAdd, addEvery: self.addEvery, dateToBegin: self.dateToBegin){ finalAmountRecived in
                                                
                                                self.name = name
                                                sum = Float(sum) + Float(finalAmountRecived)
                                                
                                                print("\(sum) +++++++++++++++++++++++++++++")
                                                
                                                SumUpdateAfterAmountAdded().sumUpdateAfterAmountAdded(oldSum: sum, amountAdded: Float(finalAmountRecived), uid: uid, kidName: name)
                                                
                                                // grab from db the cell color & picture
                                                if document.data()["cellColor"] as? String != nil {
                                                    let colorHexString = document.data()["cellColor"] as! String
                                                    self.cellColor = UIColor(hexString: "\(colorHexString)")
                                                    
                                                    
                                                    if document.data()["pictureURL"] as? String != "" {
                                                        let imageURL = document.data()["pictureURL"] as? String
                                                        let storage = Storage.storage().reference(forURL: imageURL!)
                                                        storage.getData(maxSize: 5 * 1024 * 1024) { data, error in
                                                            if let error = error {
                                                                self.kidImage = UIImage(named: "userIcon")!
                                                                print(error.localizedDescription)
                                                                
                                                                let newUser = Kid(name: name, sum:String(format: "%.2f", sum * self.rate), cellColor: self.cellColor, picture: self.kidImage)
                                                                
                                                                self.kids.append(newUser)
                                                                self.reloadData()
                                                                
                                                                
                                                            } else {
                                                                let colorHexString = document.data()["cellColor"] as! String
                                                                self.cellColor = UIColor(hexString: "\(colorHexString)")
                                                                
                                                                self.kidImage = UIImage(data: data!)!
                                                                
                                                                let newUser = Kid(name: name, sum: String(format: "%.2f", sum * self.rate), cellColor: self.cellColor, picture: self.kidImage)
                                                                
                                                                self.kids.append(newUser)
                                                                self.reloadData()
                                                                
                                                            }
                                                        }
                                                        
                                                    }else{
                                                        self.kidImage = UIImage(named: "userIcon")!
                                                        
                                                        let newUser = Kid(name: name, sum: String(format: "%.2f", sum * self.rate), cellColor: self.cellColor, picture: self.kidImage)
                                                        
                                                        self.kids.append(newUser)
                                                        self.reloadData()
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToAddUserVC", sender: self)
        
    }
    
    
    func reloadData() {
        print(self.kids)
        self.tableView.reloadData()
        self.tableView.alpha = 0.0
        
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
        UIView.animate(withDuration: 0.8) {
            self.tableView.alpha = 1.0
        }
        
    }
    
    
    func addMenuItems() -> UIMenu{
        let menuItems = UIMenu(title: "Menu", image: UIImage(systemName: "text.justify"), options: .displayInline, children: [
            UIAction(title: "Preferred Currency", handler: { (_) in
                self.performSegue(withIdentifier: "goToCurrency", sender: self)
            }),
            
            UIAction(title: "Sign Out", image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), attributes: .destructive , handler: { (_) in
                print("Sign Out")
                self.signOut()
                
            }),
            
            UIAction(title: "Delete data", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in
                self.performSegue(withIdentifier: "goToDeleteData", sender: self)
                print("delete data")
                // delete data
                
            })
            
        ])
        return menuItems
    }
    
    
    func signOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home") as? Home
            {
                self.present(vc, animated: true, completion: nil)
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func updateDefaultCurreny(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        db.collection("families").document(uid).getDocument(completion: { document, error in
            if let error = error {
                print(error)
                self.db.collection("families").document(uid).setData([
                    "currency": "ILS"
                ])
                self.currencyName = "ILS"
            }
            
            if document?.exists ?? false {
                self.currencyName = document?.data()?["currency"] as! String
            } else {
                self.db.collection("families").document(uid).setData([
                    "currency": "ILS"
                ])
                self.currencyName = "ILS"
            }
            
            
        })
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userDetailsVC = segue.destination as? UserDetailsVC {
            userDetailsVC.kidsStringToPass = kids
            userDetailsVC.kidsIndex = kidsIndex
            userDetailsVC.currencyNameToPass = currencyName
            userDetailsVC.rateToPass = rate
            print(kids)
        }
        if let addUserVC = segue.destination as? AddUserVC {
            addUserVC.rateToPass = rate
        }
    }
    
}


extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kids.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCellIdentifier", for: indexPath) as! UserCell
        
        cell.delegate = self
        
        cell.nameLabel.text = kids[indexPath.row].name
        cell.sumLabel.text = String(kids[indexPath.row].sum)
        cell.color.backgroundColor = kids[indexPath.row].cellColor
        cell.userPicture.image = kids[indexPath.row].picture
        cell.currencyLabel.text = currencyName
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        kidsIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        performSegue(withIdentifier: "goToUserDetailsVC", sender: self)
        
    }
    
    
    
    
    
}

extension MainVC: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("item deleted")
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            self.db.collection("families").document(uid).collection("kids").document(self.kids[indexPath.row].name).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            self.kids = []
            self.loadKids()
            tableView.reloadData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
