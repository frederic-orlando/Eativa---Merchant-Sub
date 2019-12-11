//
//  MenuTwoTextCell.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 10/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class MenuTwoTextCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
}
