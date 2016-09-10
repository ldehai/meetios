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

public class WordModel:NSObject {
    public var lat = ""
    public var lon = ""
    public var word:Word
    public var sysExample  = [SysExample]()
    public var userExample = [UserExample]()
    
    init(word: Word, sysExample: [SysExample], userExample: [UserExample]) {
        self.word = word
        self.sysExample = sysExample
        self.userExample = userExample
        super.init()
    }
    class func fromJSON(json: JSON) -> WordModel? {
        
        let word = Word.fromJSON(json["word"])
        
        var sysExample = [SysExample]()
        let seList = json["sys_example"].array
        for item in seList! {
            print(item["id"])
            let sample = SysExample.fromJSON(item)
            sysExample.append(sample!)
        }
        
        var userExample = [UserExample]()
        let ueList = json["user_example"].array
        for item in ueList! {
            print(item["id"])
            let sample = UserExample.fromJSON(item)
            userExample.append(sample!)
        }
        
        return WordModel(word: word!, sysExample: sysExample, userExample: userExample)
    }
}

public class Word:NSObject{
    public var name = ""
    public var id = ""
    public var pronunc = ""
    public var def_en = ""
    public var def_cn = ""
    public var uk_audio = ""
    public var us_audio = ""
    public var lon = ""
    public var lat = ""
    public var own = 0
    
    init(name: String, id: String, pronunc:String, def_en: String, def_cn: String, uk_audio:String, us_audio:String, lon:String, lat:String) {
        self.name = name
        self.id = id
        self.pronunc = pronunc
        self.def_en = def_en
        self.def_cn = def_cn
        self.uk_audio = uk_audio
        self.us_audio = us_audio
        self.lon = lon
        self.lat = lat
        
        super.init()
    }
    class func fromJSON(json: JSON) -> Word? {
        
        let name = json["content"].stringValue
        let id = json["id"].stringValue
        let pronunc = json["pronunciation"].stringValue
        let def_en = json["en_definition"].stringValue
        let def_cn = json["cn_definition"].stringValue
        let uk_audio = json["uk_audio"].stringValue
        let us_audio = json["us_audio"].stringValue
        let lon = json["lon"].stringValue
        let lat = json["lat"].stringValue
        
        return Word(name: name, id: id, pronunc:pronunc, def_en: def_en, def_cn:def_cn, uk_audio:uk_audio,us_audio:us_audio,lon:lon,lat:lat)
    }
}

public class SysExample:NSObject{
    public var id = ""
    public var content = ""
    public var translation = ""
    
    init(id: String, content: String, translation: String) {
        self.id = id
        self.content = content
        self.translation = translation
        super.init()
    }
    class func fromJSON(json: JSON) -> SysExample? {
        
        let id = json["id"].stringValue
        let content = json["content"].stringValue
        let translation = json["translation"].stringValue
        
        return SysExample(id: id, content: content, translation: translation)
    }
}

public class User:NSObject{
    var userId = ""
    var nickName = ""
    var avatar = ""
    var email = ""
    var tel = 0
    var following = 0
    var follower = 0
    var wordcount = 0
    var grade = 0
    var gradename = ""
    var golden = 0
    var contributerWord = 0
    
    init(userId: String, nickName: String, avatar: String, email:String,tel:Int,following:Int,follower:Int,wordcount:Int,grade:Int,gradename:String, golden:Int,contributerWord:Int) {
        self.userId = userId
        self.nickName = nickName
        self.avatar = avatar
        self.golden = golden
        self.email = email
        self.tel = tel
        self.following = following
        self.follower = follower
        self.wordcount = wordcount
        self.grade = grade
        self.gradename = gradename
        self.golden = golden
        self.contributerWord = contributerWord
        
        super.init()
    }
    class func fromJSON(json: JSON) -> User? {
        
        let userId = json["userid"].stringValue
        let nickName = json["nickname"].stringValue
        let avatar = json["avatar"].stringValue
        let golden = json["golden"].intValue
        let email = json["email"].stringValue
        let tel = json["tel"].intValue
        let following = json["following"].intValue
        let follower = json["follower"].intValue
        let wordcount = json["wordcount"].intValue
        let grade = json["grade"].intValue
        let gradename = json["gradename"].stringValue
        let contributerWord = json["contributerword"].intValue
        
        return User(userId: userId, nickName: nickName, avatar: avatar,email: email,tel:tel,following: following,follower: follower,wordcount: wordcount,grade: grade,gradename: gradename,golden:golden,contributerWord:contributerWord)
    }
}

public class UserExample:NSObject{
    public var id = ""
    public var content = ""
    public var translation = ""
    public var user:User
    
    init(id: String, content: String, translation: String, user:User) {
        self.id = id
        self.content = content
        self.translation = translation
        self.user = user
        super.init()
    }
    class func fromJSON(json: JSON) -> UserExample? {
        
        let id = json["id"].stringValue
        let content = json["content"].stringValue
        let translation = json["translation"].stringValue
        let user = User.fromJSON(json["user"])
        
        return UserExample(id: id, content: content, translation: translation, user:user!)
    }
}
