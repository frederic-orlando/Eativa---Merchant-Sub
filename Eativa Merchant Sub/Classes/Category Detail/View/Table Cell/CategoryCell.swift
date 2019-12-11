//
//  CategoryCell.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 06/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var badgeLbl: UILabel!
    
    var menuCategory : MenuCategory! {
        didSet {
            setupInterface()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupInterface() {
        nameTextField.text = menuCategory.name
        
        if let menuCount = menuCategory.menus?.count, menuCount > 0 {
            badgeLbl.text = String(menuCount)
        }
        else {
            badgeLbl.isHidden = true
        }
    }
    
    func updateCategoryName(_ newChar : String) {
        let currentName = menuCategory.name
        menuCategory.name = currentName! + newChar
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
}
