//
//  Config.swift
//  MeetSwift
//
//  Created by andy on 9/9/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import Foundation
import UIKit

//define color
let MainColor = UIColor(hex: "00A56F", alpha: 1.0)

//define notify
let NOTIFY_LOGIN_OK:String = "NOTIFY_LOGIN_OK"
let NOTIFY_COLLECT_WORD:String = "NOTIFY_COLLECT_WORD"
let NOTIFY_PLAY_WORD_VOICE:String = "NOTIFY_PLAY_WORD_VOICE"
let NOTIFY_LOAD_WORDLIST:String = "NOTIFY_LOAD_WORDLIST"

// MARK: - 屏幕宽高
 let kDeviceWidth = UIScreen.mainScreen().bounds.size.width
 let kDeviceheight = UIScreen.mainScreen().bounds.size.height


enum ShowMode {
    case Show         // 浏览
    case Collect      // 收集
    case Train        // 训练
};

final public class Config {
    public static let appGroupID: String = "group.AventLabs-Inc."
    
    public class func clientType() -> Int {
        // TODO: clientType
        
        #if DEBUG
            return 2
        #else
            return 0
        #endif
    }
    
    public struct Notification {
        public static let markAsReaded = "Config.Notification.markAsReaded"
    }
    
    public struct Message {
    }
}

