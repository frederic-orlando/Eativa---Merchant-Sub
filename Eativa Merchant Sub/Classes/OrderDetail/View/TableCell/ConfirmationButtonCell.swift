//
//  ButtonCell.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 29/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

protocol ConfirmationCellDelegate {
    func didPressAccept()
    func didPressDecline()
    func didPressSuggestTime()
    func didPressSendSuggestion()
}

class ConfirmationButtonCell: UITableViewCell {

    @IBOutlet weak var suggestButton: UIButton!
    
    var delegate : ConfirmationCellDelegate!
    var isSuggestingNewTime : Bool = false {
        didSet {
            let title = isSuggestingNewTime ? "Send Suggestion" : "Suggest Pick Up Time"
            suggestButton.setTitle(title, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
    @IBAction func acceptBtnPressed(_ sender: Any) {
        delegate.didPressAccept()
    }
    
    @IBAction func declineBtnPressed(_ sender: Any) {
        delegate.didPressDecline()
    }
    
    @IBAction func suggestTimeBtnPressed(_ sender: Any) {
        if isSuggestingNewTime {
            delegate.didPressSendSuggestion()
        }
        else {
            delegate.didPressSuggestTime()
        }
    }
}
