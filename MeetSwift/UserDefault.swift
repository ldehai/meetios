//
//  UserDefault.swift
//  MeetSwift
//
//  Created by andy on 9/9/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import Foundation

final public class MeetUserDefaults {
    
    static let defaults = NSUserDefaults(suiteName: Config.appGroupID)!
//    public static var isLogined: Bool {
//        
//        if let _:MeetUserDefaults.accessToken {
//            return true
//        } else {
//            return false
//        }
//    }
//    public static var userID = ""
//    public static var accessToken = ""
//    public static var nickName = ""
//    public static var introduction = ""
//    public class func cleanAllUserDefaults() {
//        
//        do {
//            MeetUserDefaults.accessToken = ""
//            MeetUserDefaults.userID = ""
//            MeetUserDefaults.nickName = ""
//            MeetUserDefaults.introduction = ""
//            defaults.synchronize()
//        }
//    }
}
