//
//  Date.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 01/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation

extension Date {
    var plusSevenGMT : Date {
        let modifiedDate = Calendar.current.date(byAdding: .hour, value: 7, to: self)!
        return modifiedDate
    }
    
    var timeString : String {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: self)
    }
    
    static func timeFrom(string : String) -> Date {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        formatter.dateFormat = "HH:mm"
        
        return formatter.date(from: string)!
    }
    
    
    // Need Fix from Customer side
    func changeDate(modifierDate : Date) -> Date {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: modifierDate)
        let month = calendar.component(.month, from: modifierDate)
        let year = calendar.component(.year, from: modifierDate)
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        
        var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())

        component.year = year
        component.month = month
        component.day = day
        
        component.hour = hour
        component.minute = minute
        
        return calendar.date(from: component)!
    }
}
