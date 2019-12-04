//
//  CurrentUser.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 28/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation

struct CurrentUser {
    static var id = ""
    static var name = ""
    static var accessToken : String = ""
    
    static func reset() {
        id = ""
        name = ""
        accessToken = ""
    }
    
    static func loadFromDefaults() {
        CurrentUser.id = Defaults.getId()
        CurrentUser.name = Defaults.getName()
        CurrentUser.accessToken = Defaults.getToken()
    }
}
