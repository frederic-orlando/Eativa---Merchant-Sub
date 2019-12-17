//
//  DetailCell.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 28/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    @IBOutlet weak var nameAndPhoneLbl: UILabel!
    @IBOutlet weak var orderNoAndPriceLbl: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var creationDateLbl: UILabel!
    @IBOutlet weak var pickUpTimeLbl: UILabel!
    @IBOutlet weak var titlePickUpTime: UILabel!
    
    var transaction : Transaction! {
        didSet {
            let customer = transaction.customer!
            if self.transaction.status == 5 {
                nameAndPhoneLbl.isHidden = true
                pickUpTimeLbl.font = pickUpTimeLbl.font.withSize(16)
                titlePickUpTime.font = titlePickUpTime.font.withSize(18)
            } else {
                nameAndPhoneLbl.text = "\(customer.name!) - \(customer.phone!)"
            }
            
            orderNoAndPriceLbl.text = "Order No: \(transaction.orderNumber!.uppercased()) | \(transaction.total!.currency)"
            pickUpTimeLbl.text = transaction.pickUpTime?.timeString
            creationDateLbl.text = "\(transaction.createdAt!.creationDate)"
            checkReminder()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        if transaction.status == 3 {
            refreshColor()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func refreshColor() {
        DispatchQueue.main.async {
            self.colorView.backgroundColor = self.transaction.isOnReminder ? .systemRed : .systemGray4
        }
    }
    
    func checkReminder() {
        if transaction.status == 3 && !transaction.isReminderDismiss {
            let pickUpTime = transaction.pickUpTime!.date
            if let processingTime = transaction.processingTime {
                let modifiedTime = Calendar.current.date(byAdding: .minute, value: -processingTime, to: pickUpTime)!
                if Date() > modifiedTime.roundedByOneMinute {
                    transaction.isOnReminder = true

                    refreshColor()
                }
            }
        }
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
}
