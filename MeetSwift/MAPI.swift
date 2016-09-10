//
//  MAPI.swift
//  MeetSwift
//
//  Created by andy on 8/27/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import Alamofire

class MAPI: NSObject {

    static let APIBase = "http://121.41.37.3:9000/api/meet"
    
    class func accessToken() -> String{
        let userDefault = NSUserDefaults .standardUserDefaults()
        if let token =  userDefault .stringForKey("accessToken"){
            return token
        }
        else{
            return ""
        }
    }
    
    //获取当前地点的可采集单词
    class func getWordsBy(
        lon:NSString,
        lat:NSString,
        completion: (respond :NSData) ->())
    {
        let parameters = ["lat":lat,
                          "lon":lon,
                          "token":MAPI .accessToken(),
                          "tags":["商场","食物","345"]];
        print(parameters)
        Alamofire.request(.POST, APIBase + "/word", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    completion(respond: response.data!)
                }
                switch response.result {
                case .Success:
                    completion(respond: response.data!)
                    
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    //根据单词查询详情
    class func getWordDetail(
        wordId:String,
        completion: (respond :NSData) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(.POST, APIBase + "/word/" + wordId, parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(respond: response.data!)
        }
    }
    
    //采集了一个单词
    class func collectWord(
        word:String,
        lon:String,
        lat:String,
        completion: (respond :NSData) ->())
    {
        let parameters = ["lat":"31.976955",
                          "lon":"118.771662",
                          "token":MAPI .accessToken(),
                          "city":"南京"];
        Alamofire.request(.POST, APIBase + "/collect/" + word, parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                completion(respond: response.data!)
        }
    }
    
    //获取当日采集的所有单词
    class func getWordsTodayCollect(completion: (respond :NSData) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(.POST, APIBase + "/word/today_list", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(respond: response.data!)
        }
    }
    
    //获取我的所有单词
    class func getMyWords(completion: (respond :NSData) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(.POST, APIBase + "/myword", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(respond: response.data!)
        }
    }
    
    //获取我的个人信息
    class func getUserProfile(completion: (respond :NSData) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(.POST, APIBase + "/user/" + "1", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(respond: response.data!)
        }
    }

    //登录
    class func signin(tel:String,password:String,completion: (respond :NSData) ->())
    {
        let parameters = ["tel":tel,"pwd":password];
        Alamofire.request(.POST, APIBase + "/signin", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(respond: response.data!)
        }
    }
    
    //注册
    class func signup(tel:String,
                      verifycode:String,
                      password:String,
                      nickName:String,
                      lon:String,
                      lat:String,
                      completion: (respond :NSData) ->())
    {
        let parameters = ["tel":tel,
                          "verifycode":verifycode,
                          "pwd":password,
                          "nickname":nickName,
                          "lon":lon,
                          "lat":lat];
        Alamofire.request(.POST, APIBase + "/signup", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(respond: response.data!)
        }
    }
    
    //获取短信验证码
    class func getVerifyCode(tel:String, completion: (respond :NSData) ->())
    {
        let parameters = ["tel":tel];
        Alamofire.request(.POST, APIBase + "/verifycode", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(respond: response.data!)
        }
    }
    
    //贡献榜
    class func getTopContributer(completion: (respond :NSData) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(.POST, APIBase + "/topcontributer", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(respond: response.data!)
        }
    }
    
    //全球排行榜
    class func getTopRankWorld(completion: (respond :NSData) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(.POST, APIBase + "/topworld", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(respond: response.data!)
        }
    }
}