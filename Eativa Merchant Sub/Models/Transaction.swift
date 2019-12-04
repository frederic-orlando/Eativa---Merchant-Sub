//
//  Transaction.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 28/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation

class Transaction : Codable{
    var id : String? // D
    var orderNumber : String?
    var customer : Customer? // D
    var merchant : Merchant? // D
    var customerId : String? // E
    var merchantId : String? // E
    var pickUpTime : String? // D, E
    var total : Int? // D, E
    var status : Int? // D, E
    var details : [TransactionDetail]? // D, E
    var createdAt : String?
    var isOnReminder : Bool = false
    var processingTime : Int = 30
    
    private enum CodingKeys: String, CodingKey {
        case id
        case orderNumber
        case customer
        case merchant
        case customerId
        case merchantId
        case pickUpTime
        case total
        case status
        case details
        case createdAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.orderNumber = try container.decodeIfPresent(String.self, forKey: .orderNumber)
        self.customer = try container.decodeIfPresent(Customer.self, forKey: .customer)
        self.merchantId = try container.decodeIfPresent(String.self, forKey: .merchantId)
        self.merchant = try container.decodeIfPresent(Merchant.self, forKey: .merchant)
        self.pickUpTime = try container.decodeIfPresent(String.self, forKey: .pickUpTime)
        self.total = try container.decodeIfPresent(Int.self, forKey: .total)
        self.status = try container.decodeIfPresent(Int.self, forKey: .status)
        self.details = try container.decodeIfPresent([TransactionDetail].self, forKey: .details)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
    }
    
    init(merchantId : String, customerId: String) {
        self.merchantId = merchantId
        self.customerId = customerId
        self.details = []
    }
    
    init(status : Int) {
        self.status = status
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(customerId, forKey: .customerId)
        try container.encode(merchantId, forKey: .merchantId)
        try container.encode(pickUpTime, forKey: .pickUpTime)
        try container.encode(total, forKey: .total)
        try container.encode(details, forKey: .details)
    }
    
    func getTotalMenu() -> Int {
        var totalMenu = 0
        
        guard let details = details else {return 0}
        for detail in details {
            totalMenu += detail.qty!
        }
        
        return totalMenu
    }
    
    func getSubTotalPrice() -> Int {
        var totalPrice = 0
        
        guard let details = details else {return 0}
        for detail in details {
            totalPrice += (detail.qty! * detail.menu!.price!)
        }
        
        return totalPrice
    }
    
    func getTaxPrice() -> Int {
        
        let taxPrice = Int(merchant!.tax! * Double(getSubTotalPrice()))
        
        return taxPrice
    }
}
