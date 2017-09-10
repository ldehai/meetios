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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        application.isStatusBarHidden = true
        
        //崩溃服务初始化(www.fabric.io)
        Fabric.with([Crashlytics.self])
        
        //配置Realm环境
        var config = Realm.Configuration()
        config.schemaVersion = 1
        config.migrationBlock = { migration, oldSchemaVersion in
        }
        Realm.Configuration.defaultConfiguration = config
        
        //没有登录时，要求登录；已登录直接到首页
        let userDefault = UserDefaults.standard
        if userDefault.object(forKey: "userId") == nil{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let userProfileVC:GuideViewController = storyboard.instantiateViewController(withIdentifier: "GuideVC") as! GuideViewController
            let nav = UINavigationController(rootViewController: userProfileVC)
            nav.navigationBar.tintColor = UIColor.black
            
            self.window?.rootViewController = nav
        }
        
        //消息监听
        NotificationCenter.default .addObserver(self, selector:#selector(openCollection), name: NSNotification.Name(rawValue: NOTIFY_OPEN_COLLECTION), object: nil)
        NotificationCenter.default .addObserver(self, selector:#selector(loginOK), name: NSNotification.Name(rawValue: NOTIFY_LOGIN_OK), object: nil)
        NotificationCenter.default .addObserver(self, selector:#selector(logoutOK), name: NSNotification.Name(rawValue: NOTIFY_LOGOUT_OK), object: nil)
        NotificationCenter.default .addObserver(self, selector:#selector(playWordVoice(_:)), name: NSNotification.Name(rawValue: NOTIFY_PLAY_WORD_VOICE), object: nil)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(types:([UIUserNotificationType.sound, UIUserNotificationType.alert, UIUserNotificationType.badge]) , categories: nil))
        
        application .registerForRemoteNotifications()
        
        //地址位置信息
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        
        return true
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        manager.startUpdatingLocation()
        
        switch status {
        case .notDetermined:
            print("用户未选择")
        case .restricted:
            print("受限制")
        case.denied:
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
        case .authorizedAlways:
            print("前后台定位授权")
        case .authorizedWhenInUse:
            print("前台定位授权")
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int){
        if buttonIndex == 1 {
            // 跳转到设置界面
            let url = URL(string: UIApplicationOpenSettingsURLString)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.openURL(url!)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
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
            
            //刷新当前地图
            NotificationCenter.default .post(name: Notification.Name(rawValue: NOTIFY_REFRESH_LOCATION), object: nil)
            self .perform(#selector(self.restartLocation), with: nil, afterDelay: 300)
            self .perform(#selector(self.stopLocation), with: nil, afterDelay: 20)
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
    
    func openCollection(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let collectVC:CollectWordsViewController = storyboard.instantiateViewController(withIdentifier: "CollectWords") as! CollectWordsViewController
        let nav = UINavigationController(rootViewController: collectVC)
        self.window?.rootViewController = nav

    }
    
    func loginOK(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let userProfileVC:ViewController = storyboard.instantiateViewController(withIdentifier: "rootVC") as! ViewController
        let nav = UINavigationController(rootViewController: userProfileVC)
        
        self.window?.rootViewController = nav
    }
    
    func logoutOK(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let userProfileVC:GuideViewController = storyboard.instantiateViewController(withIdentifier: "GuideVC") as! GuideViewController
        let nav = UINavigationController(rootViewController: userProfileVC)
        nav.navigationBar.tintColor = UIColor.black
        
        self.window?.rootViewController = nav
    }
    
    var player = AVPlayer()
    func playWordVoice(_ notify:Notification){
        let voicePath = notify.object as? String
        if voicePath == nil {
            return
        }
        
        let url = SRCBaseURL + voicePath!
        let playerItem = AVPlayerItem( url:URL( string:url )! )
        player = AVPlayer(playerItem:playerItem)
        player.rate = 1.0;
        player.play()
        
        print("play")
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error){
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]){
        
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification){
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        let notification = UILocalNotification()
//        notification.alertBody = "我会在后台"
//        notification.alertAction = "Open"
//        application.presentLocalNotificationNow(notification)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

