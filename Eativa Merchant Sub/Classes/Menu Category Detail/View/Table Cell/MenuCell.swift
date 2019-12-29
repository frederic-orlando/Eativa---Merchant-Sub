//
//  MenuCell.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 09/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    var menu : Menu! {
        didSet {
            nameLbl.text = menu.name!
            priceLbl.text = menu.price!.currency
            
            setupImageBorder()
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
    
    func setupImageBorder() {
        let imageLayer = menuImage.layer
        imageLayer.borderWidth = 2
        imageLayer.borderColor = menu.isAvailable! ? UIColor.green.cgColor : UIColor.red.cgColor
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
}
