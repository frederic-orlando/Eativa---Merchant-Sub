//
//  AddCategoryCell.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 06/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class AddCategoryCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
}
