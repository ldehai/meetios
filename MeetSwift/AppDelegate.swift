//
//  AppDelegate.swift
//  MeetSwift
//
//  Created by andy on 8/23/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //崩溃服务初始化(www.fabric.io)
        Fabric.with([Crashlytics.self])
        
        //配置Realm环境
        var config = Realm.Configuration()
        config.schemaVersion = 1
        config.migrationBlock = { migration, oldSchemaVersion in
        }
        Realm.Configuration.defaultConfiguration = config
        
        //没有登录时，要求登录；已登录直接到首页
        let userDefault = NSUserDefaults .standardUserDefaults()
        if userDefault.objectForKey("userId") == nil{
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let userProfileVC:GuideViewController = storyboard.instantiateViewControllerWithIdentifier("GuideVC") as! GuideViewController
            let nav = UINavigationController(rootViewController: userProfileVC)
            
            self.window?.rootViewController = nav
        }
        
        //消息监听
        NSNotificationCenter .defaultCenter() .addObserver(self, selector:#selector(loginOK), name: NOTIFY_LOGIN_OK, object: nil)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes:([UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge]) , categories: nil))
        
        application .registerForRemoteNotifications()
        
        return true
    }

    func loginOK(){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let userProfileVC:ViewController = storyboard.instantiateViewControllerWithIdentifier("rootVC") as! ViewController
        let nav = UINavigationController(rootViewController: userProfileVC)
        
        self.window?.rootViewController = nav
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData){
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError){
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]){
        
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification){
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        let notification = UILocalNotification()
        notification.alertBody = "我会在后台"
        notification.alertAction = "Open"
        application.presentLocalNotificationNow(notification)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

