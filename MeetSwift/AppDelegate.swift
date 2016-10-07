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
import AVFoundation
import MapKit
import FoursquareAPIClient

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,UIAlertViewDelegate {

    var window: UIWindow?
    var coordinate:CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    var lat = ""
    var lon = ""
    var city = ""
    var isCollect = false

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        application.statusBarHidden = true
        
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
            nav.navigationBar.tintColor = UIColor.blackColor()
            
            self.window?.rootViewController = nav
        }
        
        //消息监听
        NSNotificationCenter .defaultCenter() .addObserver(self, selector:#selector(loginOK), name: NOTIFY_LOGIN_OK, object: nil)
        NSNotificationCenter .defaultCenter() .addObserver(self, selector:#selector(logoutOK), name: NOTIFY_LOGOUT_OK, object: nil)
        NSNotificationCenter .defaultCenter() .addObserver(self, selector:#selector(playWordVoice(_:)), name: NOTIFY_PLAY_WORD_VOICE, object: nil)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes:([UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge]) , categories: nil))
        
        application .registerForRemoteNotifications()
        
        //地址位置信息
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        
        return true
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        manager.startUpdatingLocation()
        
        switch status {
        case .NotDetermined:
            print("用户未选择")
        case .Restricted:
            print("受限制")
        case.Denied:
            print("被拒绝")
            if CLLocationManager .locationServicesEnabled() { // 定位服务开启
                print("用户真正拒绝")
                
                let alert = UIAlertView(title: "提醒", message: "Meet英语需要开启定位才能采集单词，现在去开启吗?", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                alert.show()
                
            } else {
                print("服务未开启")
                
                let alert = UIAlertView(title: "提醒", message: "Meet英语需要开启定位才能采集单词", delegate: nil, cancelButtonTitle: "知道了")
                alert.show()
            }
        case .AuthorizedAlways:
            print("前后台定位授权")
        case .AuthorizedWhenInUse:
            print("前台定位授权")
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if buttonIndex == 1 {
            // 跳转到设置界面
            let url = NSURL(string: UIApplicationOpenSettingsURLString)
            if UIApplication.sharedApplication().canOpenURL(url!) {
                UIApplication.sharedApplication().openURL(url!)
            }
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                var city = pm.locality
                print(city)
                if city == nil{
                    city = ""
                }
                self.city = city!
            }
            
            self.lat = (locations.last?.coordinate.latitude.description)!
            self.lon = (locations.last?.coordinate.longitude.description)!

            if (self.isCollect) {
                return;
            }
            self .performSelector(#selector(self.restartLocation), withObject: nil, afterDelay: 300)
            self .performSelector(#selector(self.stopLocation), withObject: nil, afterDelay: 20)
            self.isCollect = true
        })
    }

    func restartLocation(){
        self.locationManager .startUpdatingLocation()
    }
    
    func stopLocation(){
        self.locationManager .stopUpdatingLocation()
        self.isCollect = false
    }
    
    func loginOK(){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let userProfileVC:ViewController = storyboard.instantiateViewControllerWithIdentifier("rootVC") as! ViewController
        let nav = UINavigationController(rootViewController: userProfileVC)
        
        self.window?.rootViewController = nav
    }
    
    func logoutOK(){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let userProfileVC:GuideViewController = storyboard.instantiateViewControllerWithIdentifier("GuideVC") as! GuideViewController
        let nav = UINavigationController(rootViewController: userProfileVC)
        nav.navigationBar.tintColor = UIColor.blackColor()
        
        self.window?.rootViewController = nav
    }
    
    var player = AVPlayer()
    func playWordVoice(notify:NSNotification){
        let voicePath = notify.object as? String
        if voicePath == nil {
            return
        }
        
        let url = SRCBaseURL + voicePath!
        let playerItem = AVPlayerItem( URL:NSURL( string:url )! )
        player = AVPlayer(playerItem:playerItem)
        player.rate = 1.0;
        player.play()
        
        print("play")
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
//        let notification = UILocalNotification()
//        notification.alertBody = "我会在后台"
//        notification.alertAction = "Open"
//        application.presentLocalNotificationNow(notification)
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

