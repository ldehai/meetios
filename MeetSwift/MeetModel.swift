//
//  MeetModel.swift
//  MeetSwift
//
//  Created by andy on 9/7/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift
import Realm

public class WordModel:Object {
    dynamic var id = ""
    dynamic var collectTime = NSDate()
    dynamic var word:Word? = Word()
    var sysExample = List<SysExample>()
    var userExample = List<UserExample>()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    class func fromJSON(json: JSON) -> WordModel? {
        
        let p = WordModel()
        
        let word = Word.fromJSON(json["word"])
        
        let sysExample = List<SysExample>()
        let seList = json["sys_example"].array
        for item in seList! {
            print(item["id"])
            let sample = SysExample.fromJSON(item)
            sysExample.append(sample!)
        }
        
        let userExample = List<UserExample>()
        let ueList = json["user_example"].array
        for item in ueList! {
            print(item["id"])
            let sample = UserExample.fromJSON(item)
            userExample.append(sample!)
        }
        
        p.sysExample = sysExample
        p.userExample = userExample
        p.word = word!
        p.id = word!.id
        p.collectTime = (word?.collectTime)!
        
        return p
    }
}

public class Word:Object{
    dynamic var name = ""
    dynamic var id = ""
    dynamic var pronunc = ""
    dynamic var def_en = ""
    dynamic var def_cn = ""
    dynamic var uk_audio = ""
    dynamic var us_audio = ""
    dynamic var lon = ""
    dynamic var lat = ""
    dynamic var own = 0
    dynamic var collectTime = NSDate()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    class func fromJSON(json: JSON) -> Word? {
        let p = Word()
        p.name = json["content"].stringValue
        p.id = json["id"].stringValue
        p.pronunc = json["pronunciation"].stringValue
        p.def_en = json["en_definition"].stringValue
        p.def_cn = json["cn_definition"].stringValue
        p.uk_audio = json["uk_audio"].stringValue
        p.us_audio = json["us_audio"].stringValue
        p.lon = json["lon"].stringValue
        p.lat = json["lat"].stringValue
        
        //把日期从字符串转换到NSDate类型
        let collectTime:String? = json["collecttime"].stringValue
        if collectTime != nil && collectTime?.length > 0 {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = NSTimeZone(name: "GMT")
            let date = formatter .dateFromString(collectTime!)
            p.collectTime = date!
        }
        
        return p
    }
}

public class SysExample:Object{
    dynamic var id = ""
    dynamic var content = ""
    dynamic var translation = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    class func fromJSON(json: JSON) -> SysExample? {
        let p = SysExample()
        p.id = json["id"].stringValue
        p.content = json["content"].stringValue
        p.translation = json["translation"].stringValue
        
        return p
    }
}

public class User:Object{
    var userId: String?
    var nickName: String?
    var avatar: String?
    var email: String?
    var tel:Int = 0
    var following:Int = 0
    var follower:Int = 0
    var todaywords:Int = 0
    var wordcount:Int = 0
    var grade:Int = 0
    var gradename: String?
    var golden:Int = 0
    var contributerWord:Int = 0

    override public static func primaryKey() -> String? {
        return "userId"
    }
    
    class func fromJSON(json: JSON) -> User? {
        let p = User()
        p.userId = json["userid"].stringValue
        p.nickName = json["nickname"].stringValue
        p.avatar = json["avatar"].stringValue
        p.golden = json["golden"].intValue
        p.email = json["email"].stringValue
        p.tel = json["tel"].intValue
        p.following = json["following"].intValue
        p.follower = json["follower"].intValue
        p.todaywords = json["todaywords"].intValue
        p.wordcount = json["wordcount"].intValue
        p.grade = json["grade"].intValue
        p.gradename = json["gradename"].stringValue
        p.contributerWord = json["contributerword"].intValue
        
        return p
    }
}

public class UserExample:Object{
    dynamic var id = ""
    dynamic var content = ""
    dynamic var translation = ""
    dynamic var user:User? = User()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    class func fromJSON(json: JSON) -> UserExample? {
        let p = UserExample()
        
        p.id = json["id"].stringValue
        p.content = json["content"].stringValue
        p.translation = json["translation"].stringValue
        p.user = User.fromJSON(json["user"])!
        
        return p
    }
}

public class RecommendCity:Object{
    dynamic var id = ""
    dynamic var code = ""
    dynamic var name = ""
    dynamic var lon = ""
    dynamic var lat = ""
    dynamic var thumbnail = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    class func fromJSON(json: JSON) -> RecommendCity? {
        let p = RecommendCity()
        
        p.id = json["id"].stringValue
        p.code = json["code"].stringValue
        p.name = json["name"].stringValue
        p.lon = json["lon"].stringValue
        p.lat = json["lat"].stringValue
        p.thumbnail = json["thumbnail"].stringValue
        
        return p
    }
}