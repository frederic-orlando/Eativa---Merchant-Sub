//
//  PusherBeams.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 02/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import PushNotifications

struct PusherBeams {
    
    // Beams
    static let pushNotifications = PushNotifications.shared
    static let instanceId = "f4175959-3847-4a45-aadc-2ca1a3cf752a"
    
    static func initPushNotifications() {
        // Pusher Beams Notification
        pushNotifications.start(instanceId: instanceId)
        pushNotifications.registerForRemoteNotifications()
        
        if ( CurrentUser.id != "" ) {
            registerDeviceInterest(pushInterest: CurrentUser.id)
        }
    }
    
    static func registerDeviceInterest(pushInterest: String) {
            try? self.pushNotifications.addDeviceInterest(interest: pushInterest)
    }
    
    static func removeDeviceInterest(pushInterest: String) {
            try? self.pushNotifications.removeDeviceInterest(interest: pushInterest)
    }
}
