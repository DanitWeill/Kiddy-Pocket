//
//  UserDetailsCell.swift
//  Pocket Money
//
//  Created by Danit on 13/02/2022.
//

import UIKit

class UserDetailsCell: UITableViewCell {

   
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountAddedLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

       
//        stackView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
