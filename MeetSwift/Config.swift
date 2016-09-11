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
let MainColor = UIColor(hex: "00A56F")

//define notify
let NOTIFY_LOGIN_OK:String = "NOTIFY_LOGIN_OK"

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

