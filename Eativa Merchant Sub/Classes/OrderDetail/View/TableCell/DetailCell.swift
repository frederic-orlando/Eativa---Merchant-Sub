//
//  ItemCell.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 29/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    @IBOutlet weak var menuNameLbl: UILabel!
    @IBOutlet weak var notesLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    var detail : TransactionDetail! {
        didSet {
            let menu = detail.menu!
            let qty = detail.qty!
            menuNameLbl.text = menu.name!
            
            if detail.notes == ""  || detail.notes == nil {
                notesLbl.isHidden = true
            }
            else {
                notesLbl.text = "Notes : " + detail.notes!
            }
            
            qtyLbl.text = "Qty : \(qty)"
            priceLbl.text = (qty * menu.price!).currency
        }
    }
    
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
