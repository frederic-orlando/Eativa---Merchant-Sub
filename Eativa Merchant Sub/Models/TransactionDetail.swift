//
//  TransactionDetail.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 28/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation

class TransactionDetail : Codable {
    var transactionId : String? // E
    var menu : Menu? // D
    var menuId : String? // E
    var qty : Int? // D, E //
    var notes : String?
    
    private enum CodingKeys: String, CodingKey{
        case transactionId
        case menu
        case menuId
        case qty
        case notes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //transactionID = try container.decodeIfPresent(String.self, forKey: .transactionID)
        menu = try container.decodeIfPresent(Menu.self, forKey: .menu)
        qty = try container.decodeIfPresent(Int.self, forKey: .qty)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        
        //notes = "ga pake cabe, bawang, saos, telor, daging, roti, dll"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encode(menuId, forKey: .menuId)
        try container.encode(qty, forKey: .qty)
        try container.encode(notes, forKey: .notes)
        
    }
}
