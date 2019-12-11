//
//  MenuButtonCell.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 11/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

protocol MenuButtonDelegate {
    func didPressButton(menuId : String)
}

class MenuButtonCell: UITableViewCell {

    var delegate : MenuButtonDelegate!
    
    var menuId : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didPressBtn(_ sender: Any) {
        delegate.didPressButton(menuId: menuId)
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
}
