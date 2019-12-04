//
//  ReminderAlert.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 02/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import UIKit

class CountDownAlert {
    static var textField : UITextField!
    static var picker : UIDatePicker!
    static var vc : UIViewController!
    static var alert : UIAlertController!
    
    static func show(on vc: UIViewController){
        self.vc = vc
        
        let alert = UIAlertController(title: "Setup Reminder", message: nil, preferredStyle: .alert)
        self.alert = alert
        
        alert.addTextField()
        
        self.textField = alert.textFields!.first!
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        
        self.picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.minuteInterval = 10
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        textField.inputView = picker
        
        alert.addAction(UIAlertAction(title: "Skip", style: .default, handler: { (action) in
            //vc.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Add Reminder", style: .default, handler: { (action) in
            
        }))
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    static func findDateDiff(time1: Date, time2: Date) -> String {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "hh:mm a"

        //You can directly use from here if you have two dates

        let interval = time2.timeIntervalSince(time1)
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let intervalInt = Int(interval)
        return "\(intervalInt < 0 ? "-" : "+") \(Int(hour)) Hours \(Int(minute)) Minutes"
    }
    
    @objc static func dateChanged() {
        let minutes = Int(picker.countDownDuration / 60)
        
        textField.text = "\(minutes) minute(s)"
    }
}

