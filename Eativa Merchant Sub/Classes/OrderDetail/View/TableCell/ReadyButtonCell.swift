//
//  ReadyButtonCell.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 29/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

protocol FoodReadyCellDelegate {
    func didPressReady()

}

class ReadyButtonCell: UITableViewCell {

    var delegate : FoodReadyCellDelegate!
    
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
    
    @IBAction func foodReadyPressed(_ sender: Any) {
        delegate.didPressReady()
    }
}
