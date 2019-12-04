//
//  AppDelegate.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 27/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit
import PusherSwift
import PushNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PusherDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        PusherBeams.initPushNotifications()
        PusherBeams.registerDeviceInterest(pushInterest: "global")
        
        PusherChannels.initPusherChannel()
        PusherChannels.pusher.delegate = self
        
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if interfaceIdiom == .phone {
            return .portrait
        }
        else {
            return [.portrait, .landscapeLeft]
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PusherBeams.pushNotifications.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        PusherBeams.pushNotifications.handleNotification(userInfo: userInfo)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

