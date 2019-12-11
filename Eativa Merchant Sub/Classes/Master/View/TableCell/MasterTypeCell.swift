//
//  MasterTableViewCell.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 27/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class MasterTypeCell: UITableViewCell {
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var badgeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBadge()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            backgroundColor = .systemOrange
            typeLbl.textColor = .white
        }
        else {
            backgroundColor = .white
            typeLbl.textColor = .black
        }
    }

    func setupBadge() {
        badgeLbl.backgroundColor = .appGreen
        badgeLbl.layer.cornerRadius = badgeLbl.frame.height/2
        badgeLbl.clipsToBounds = true
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
}
