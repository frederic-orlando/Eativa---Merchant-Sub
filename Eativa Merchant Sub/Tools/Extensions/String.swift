//
//  String.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 28/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import CryptoKit

extension String {
    var timeString : String {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        formatter.dateFormat = "HH:mm:ss"
        
        let date = formatter.date(from: self)!
        
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: date)
    }
    
    var time : Date {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        formatter.dateFormat = "HH:mm:ss"
        
        return formatter.date(from: self)!
    }
    
    var date : Date {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        return formatter.date(from: self)!
    }
    
    var creationDate: String {
        let formatter = DateFormatter()

        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let date = self.date
        let modifiedDate = date.plusSevenGMT
        
        formatter.dateFormat = "dd MMMM yyyy '| Order Time:' HH.mm"
        
        return formatter.string(from: modifiedDate)
    }
    
    var encrypted : String {
        let passwordString = self
        let salt = "aKnasdJaOmuHn{r8+i129sa.[fa"
        let passwordData = Data((passwordString + salt).utf8)

        let hashed = SHA256.hash(data: passwordData)

        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()

        return hashString
    }
}
