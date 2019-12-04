//
//  PickerCell.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 29/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

protocol PickerCellDelegate {
    func didChangePickUpTime(newTime : Date)
}

class PickerCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pickUpTextField: UITextField!
    @IBOutlet weak var timeChangesView: UIView!
    @IBOutlet weak var initialTimeLbl: UILabel!
    
    var delegate : PickerCellDelegate!
    
    var pickUpTime : Date! {
        didSet {
            pickUpTextField.text = pickUpTime.timeString
        }
    }
    
    var initialTime : Date! {
           didSet {
               initialTimeLbl.text = initialTime.timeString
           }
       }
    
    var item : OrderDetailViewModelPickerItem! {
        didSet {
            pickUpTime = item.newPickUpTime
            initialTime = item.pickUpTime
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timeChangesView.isHidden = true

        pickUpTextField.addOneBtnToolBar(btnTitle: "Done", target: self, selector: #selector(donePressed))
        setupDatePickerInput()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupDatePickerInput() {
        let datePicker : UIDatePicker = {
            let picker = UIDatePicker()
            picker.datePickerMode = .time
            
            picker.minuteInterval = 10
            picker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
            
            return picker
        }()

        pickUpTextField.inputView = datePicker
    }
    
    @objc func datePickerChanged(_ sender : UIDatePicker) {
        let newTime = sender.date
        
        timeChangesView.isHidden = newTime.timeString == pickUpTime.timeString
        
        item.newPickUpTime = newTime
        pickUpTextField.text = newTime.timeString
        delegate.didChangePickUpTime(newTime: newTime)
    }
    
    @objc func donePressed() {
        endEditing(true)
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
}
