//
//  Int.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 01/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation

extension Int {
    var currency : String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale(identifier: "id_ID")

        return currencyFormatter.string(from: self as NSNumber)!
    }
}
