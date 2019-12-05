//
//  MenuCell.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 04/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    var menu : Menu! {
        didSet {
            nameLbl.text = menu.name!
            priceLbl.text = menu.price!.currency
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
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
