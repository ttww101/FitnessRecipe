//
//  AppDelegate.swift
//  FitnessRecipe
//
//  Created by Apple on 5/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import LeanCloud
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate {

    var window: UIWindow?
    let kJPushAppKey = "bfd6fc6d6be2f9e726fc8ead"
    let kJPushChannel = "Publish channel"
    let kJPushProduction = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: FRTabBarController())
        window?.makeKeyAndVisible()
        
        do {
            try LCApplication.default.set(
                id:  "pIkUPyU0HbVP7NGDxNniTYUq-gzGzoHsz",
                key: "iq7MQf5DhzGYLX9brQusUQV5"
            )
        } catch {
            print("")
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted, error in
            if granted {
                print("yes")
            }
            else {
                print("no")
            }
            
        })
        
        let entity = JPUSHRegisterEntity()
        
        if #available(iOS 12.0, *) {
            //高于 iOS 12.0
            entity.types = Int(JPAuthorizationOptions.alert.rawValue|JPAuthorizationOptions.badge.rawValue|JPAuthorizationOptions.sound.rawValue|JPAuthorizationOptions.providesAppNotificationSettings.rawValue)
        } else {
            //低于 iOS 12.0
            entity.types = Int(JPAuthorizationOptions.alert.rawValue|JPAuthorizationOptions.badge.rawValue|JPAuthorizationOptions.sound.rawValue)
        }
        
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        JPUSHService.setup(withOption: launchOptions, appKey: kJPushAppKey, channel: kJPushChannel, apsForProduction: kJPushProduction)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if let trigger = notification.request.trigger {
            if trigger.isKind(of: UNPushNotificationTrigger.self) {
                JPUSHService.handleRemoteNotification(userInfo)
            }
        }
        completionHandler(Int(JPAuthorizationOptions.alert.rawValue|JPAuthorizationOptions.badge.rawValue|JPAuthorizationOptions.sound.rawValue))
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        print("notification request: \(userInfo)")
        if let trigger = response.notification.request.trigger {
            if trigger.isKind(of: UNPushNotificationTrigger.self) {
                JPUSHService.handleRemoteNotification(userInfo)
            }
        }
        completionHandler()
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        if let notification = notification {
            if let notification = notification.request.trigger{
                if notification.isKind(of: UNPushNotificationTrigger.self) {
                    //从通知界面直接进入应用
                }else{
                    //从通知设置界面进入应用
                }
            }
        }
    }
}

