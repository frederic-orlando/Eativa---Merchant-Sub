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
        
        //formatter.locale = Locale(identifier: "en_US_POSIX")
        
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: self.date)
    }
    
    var date : Date {
        let formatter = DateFormatter()
        
        //formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = formatter.date(from: self)!
        
        return date
    }
    
    var creationDate: String {
        let formatter = DateFormatter()

        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let date = self.date
        
        formatter.dateFormat = "dd MMMM yyyy '| Order Time:' HH.mm"
        
        return formatter.string(from: date)
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
