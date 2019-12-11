//
//  MenuTextSwitchCell.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 10/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class MenuTextSwitchCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupSwitch()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupSwitch() {
        switchControl.tintColor = .systemRed
        switchControl.layer.cornerRadius = switchControl.frame.height / 2
        switchControl.backgroundColor = .systemRed
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
}
