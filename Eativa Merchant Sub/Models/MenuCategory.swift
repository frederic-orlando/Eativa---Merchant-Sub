//
//  MenuCategory.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 04/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation

class MenuCategory : Codable {
    var id : String?
    var name : String?
    var menus : [Menu]?
    
    private enum CodingKeys: String, CodingKey{
        case id
        case name
        case menus
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        menus = try container.decodeIfPresent([Menu].self, forKey: .menus)
    }
    
    init(name : String, menus : [Menu]) {
        self.name = name
        self.menus = menus
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(transactionId, forKey: .transactionId)
//        try container.encode(menuId, forKey: .menuId)
//        try container.encode(qty, forKey: .qty)
//        try container.encode(notes, forKey: .notes)
    }
}
