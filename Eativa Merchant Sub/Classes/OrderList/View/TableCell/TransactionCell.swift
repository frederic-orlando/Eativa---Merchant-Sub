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
    
    var reminderTimer = Timer()
    
    var transaction : Transaction! {
        didSet {
            let customer = transaction.customer!
            nameAndPhoneLbl.text = "\(customer.name!) - \(customer.phone!)"
            orderNoAndPriceLbl.text = "Order No: \(transaction.orderNumber!) | \(transaction.total!.currency)"
            pickUpTimeLbl.text = transaction.pickUpTime!.timeString
            creationDateLbl.text = "\(transaction.createdAt!.creationDate)"
            checkReminder()
            setupTimer()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        if transaction.status == 2 {
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
    
    func setupTimer() {
        if transaction.status == 2 && !transaction.isOnReminder {
           reminderTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(checkReminder), userInfo: nil, repeats: true)
        }
    }
    
    @objc func checkReminder() {
        if transaction.status == 2 {
            let createdAt = transaction.createdAt!.date
            let pickUpTime = transaction.pickUpTime!.time.changeDate(modifierDate: createdAt)
            //print("\(pickUpTime), Price: \(transaction.total?.currency)")
            let processingTime = transaction.processingTime
            
            let modifiedTime = Calendar.current.date(byAdding: .minute, value: -processingTime, to: pickUpTime)!
            
            if Date().plusSevenGMT > modifiedTime {
                print("\(modifiedTime), Price: \(transaction.total?.currency)")
                transaction.isOnReminder = true
                refreshColor()
                reminderTimer.invalidate()
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
