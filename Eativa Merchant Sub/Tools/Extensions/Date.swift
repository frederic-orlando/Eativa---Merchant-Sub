//
//  Date.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 01/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation

extension Date {
//    var plusSevenGMT : Date {
//        let modifiedDate = Calendar.current.date(byAdding: .hour, value: 7, to: self)!
//        return modifiedDate
//    }
    
    var timeString : String {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: self)
    }
    
//    static func timeFrom(string : String) -> Date {
//        let formatter = DateFormatter()
//
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//
//        formatter.dateFormat = "HH:mm"
//
//        return formatter.date(from: string)!
//    }
    var roundedByTenMinute : Date {
        let rounded = Date(timeIntervalSinceReferenceDate: (self.timeIntervalSinceReferenceDate / 600.0).rounded(.up) * 600.0)
        print("Rounded Date: ", rounded)
        
        return rounded
    }
    
    var roundedByOneMinute : Date {
        let rounded = Date(timeIntervalSinceReferenceDate: (self.timeIntervalSinceReferenceDate / 60.0).rounded(.down) * 60.0)
        print("Rounded One Minute: ", rounded)
        
        return rounded
    }
}
