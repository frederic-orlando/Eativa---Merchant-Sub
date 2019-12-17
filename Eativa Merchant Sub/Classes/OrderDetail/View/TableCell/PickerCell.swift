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
    func didChangeReminderTime(minutes : Int)
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
            newPickUpTime = pickUpTime
            initialTimeLbl.text = pickUpTime.timeString
        }
    }
    
    var newPickUpTime : Date!
    
    var reminderTime : Int? {
        didSet {
            if reminderTime != nil {
                pickUpTextField.text = "\(reminderTime) minutes"
            }
            else {
                pickUpTextField.text = ""
            }
        }
    }
    
    var row : Int! {
        didSet {
            if row == 1 {
                pickUpTextField.placeholder = "Set Reminder"
                pickUpTextField.text = ""
            }
            
            setupDatePickerInput()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timeChangesView.isHidden = true

        pickUpTextField.addOneBtnToolBar(btnTitle: "Done", target: self, selector: #selector(donePressed))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupDatePickerInput() {
        let datePicker : UIDatePicker = {
            let picker = UIDatePicker()
            
            var mode : UIDatePicker.Mode
            
            if row == 0 {
                mode = .time
                picker.addTarget(self, action: #selector(timePickerChanged), for: .valueChanged)
            }
            else {
                mode = .countDownTimer
                picker.addTarget(self, action: #selector(countDownPickerChanged), for: .valueChanged)
            }
            
            picker.datePickerMode = mode
            
            picker.minuteInterval = 10
            
            return picker
        }()

        pickUpTextField.inputView = datePicker
    }
    
    @objc func timePickerChanged(_ sender : UIDatePicker) {
        let newTime = sender.date
        
        timeChangesView.isHidden = newTime.timeString == pickUpTime.timeString
        
        newPickUpTime = newTime
        pickUpTextField.text = newTime.timeString
        delegate.didChangePickUpTime(newTime: newTime)
    }
    
    @objc func countDownPickerChanged(_ sender : UIDatePicker) {
        let minutes = Int(sender.countDownDuration / 60)
        DispatchQueue.main.async {
            self.pickUpTextField.text = "\(minutes) minute(s)"
        }
        delegate.didChangeReminderTime(minutes: minutes)
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
