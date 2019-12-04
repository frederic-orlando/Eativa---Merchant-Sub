//
//  Defaults.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 28/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation

struct Defaults {
    static let userLogin = "userLogin"
    static let id = "merchantId"
    static let name = "merchantName"
    static let token = "merchantToken"
    
    static func saveMerchantData(id: String, name: String, token: String){
        UserDefaults.standard.set(id, forKey: self.id)
        print(name)
        UserDefaults.standard.set(name, forKey: self.name)
        UserDefaults.standard.set(token, forKey: self.token)
    }
    
    
    static func getId() -> String{
        let merchantId = UserDefaults.standard.string(forKey: id) ?? ""
        
        return merchantId
    }
    
    
    static func getName() -> String{
        let merchantName = UserDefaults.standard.string(forKey: name) ?? ""
        
        return merchantName
    }
    
    static func getToken() -> String{
        let merchantToken = UserDefaults.standard.string(forKey: token) ?? ""
        
        return merchantToken
    }
    
    static func saveUserLogin(_ isUserLogin: Bool){
        UserDefaults.standard.set(isUserLogin, forKey: userLogin)
    }
    
    static func getUserLogin() -> Bool {
        let userLogin = UserDefaults.standard.bool(forKey: self.userLogin)
        
        return userLogin
    }
    
    static func clearUserData(){
        UserDefaults.standard.removeObject(forKey: userLogin)
        UserDefaults.standard.removeObject(forKey: id)
        UserDefaults.standard.removeObject(forKey: name)
        UserDefaults.standard.removeObject(forKey: token)
    }
}
