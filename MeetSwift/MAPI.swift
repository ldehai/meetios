//
//  MAPI.swift
//  MeetSwift
//
//  Created by andy on 8/27/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import Alamofire
import ImageIO
import SwiftyJSON

//let APIBase = "http://121.41.37.3:9000/api/meet"
//let ImageBaseURL = "http://121.41.37.3:9000/static/upload/"
let APIBase = "http://www.aventlabs.com:9000/api/meet"
let SRCBaseURL = "http://www.aventlabs.com:9000/static/upload/"

class MAPI: NSObject {
    class func accessToken() -> String{
        let userDefault = NSUserDefaults .standardUserDefaults()
        if let token =  userDefault .stringForKey("accessToken"){
            return token
        }
        else{
            return ""
        }
    }
    
    class func userId() -> String{
        let userDefault = NSUserDefaults .standardUserDefaults()
        if let userId =  userDefault .stringForKey("userId"){
            return userId
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
                          "tags":["商场","食物"]];
        print(parameters)
        Alamofire.request(.POST, APIBase + "/word", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
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
            .responseString { response in
//                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
                }
                
                let convertStr = MAPI .stringByRemovingControlCharacters(response.result.value!)
                completion(respond: convertStr.dataUsingEncoding(NSUTF8StringEncoding)!)
        }
    }
    
    class func stringByRemovingControlCharacters(inputString:String) ->String
    {
        let mutable = NSMutableString(string: inputString)
        
        let controlChars = NSCharacterSet .newlineCharacterSet
        var range = mutable .rangeOfCharacterFromSet(controlChars())
        if range.location != NSNotFound
        {
            while range.location != NSNotFound {
                mutable .deleteCharactersInRange(range)
                range = mutable .rangeOfCharacterFromSet(controlChars())
            }
        }
        
        return mutable as String;
    }
    
    //采集了一个单词
    class func collectWord(
        word:String,
        lon:String,
        lat:String,
        city:String,
        completion: (respond :NSData) ->())
    {
        let parameters = ["lat":lat,
                          "lon":lon,
                          "token":MAPI .accessToken(),
                          "city":city];
        Alamofire.request(.POST, APIBase + "/collect/" + word, parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                completion(respond: response.data!)
        }
    }

    //采集了一个单词
    class func reviseComplete(completion: (respond :NSData) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(.POST, APIBase + "/revisecomplete", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
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
            .responseString { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                let convertStr = MAPI .stringByRemovingControlCharacters(response.result.value!)
                completion(respond: convertStr.dataUsingEncoding(NSUTF8StringEncoding)!)
        }
    }
    
    //获取我的所有单词
    class func getMyWords(lastWordId:String,completion: (respond :NSData) ->())
    {
        let parameters = ["token":MAPI .accessToken(),"lastWordId":lastWordId];
        Alamofire.request(.POST, APIBase + "/myword", parameters: parameters, encoding: .JSON)
            .responseString { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                let convertStr = MAPI .stringByRemovingControlCharacters(response.result.value!)
                completion(respond: convertStr.dataUsingEncoding(NSUTF8StringEncoding)!)
        }
    }
    
    //获取我的个人信息
    class func getUserProfile(userId:String,completion: (respond :NSData) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(.POST, APIBase + "/user/" + userId, parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
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
                if response.result .isSuccess == false{
                    return
                }
                
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
                if response.result .isSuccess == false{
                    return
                }
                
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
        Alamofire.request(.POST, APIBase + "/getverifycode", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(respond: response.data!)
        }
    }
    
    //验证短信验证码
    class func verifyCode(tel:String,verifycode:String, completion: (respond :NSData) ->())
    {
        let parameters = ["tel":tel,"verifycode":verifycode];
        Alamofire.request(.POST, APIBase + "/verifycode", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(respond: response.data!)
        }
    }
    
    //上传头像
    class func updateAvatar(image:String, completion: (respond :NSData) ->())
    {
        let imageData = UIImagePNGRepresentation(UIImage(contentsOfFile: image)!)!

        Alamofire.upload(
            .POST,
            APIBase + "/avatar/" + MAPI .userId(),
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: imageData, name: "image",fileName: "anyname", mimeType: "image/png")
            },
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                        }
                        
                        completion(respond: response.data!)
                    }
                    
                case .Failure(_):
                    break
                    // failure block
                }
        })
    }
    
    //推荐城市
    class func getRecommendCity(completion: (respond :NSData) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(.POST, APIBase + "/recommendcity", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
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
                if response.result .isSuccess == false{
                    return
                }
                
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
                if response.result .isSuccess == false{
                    return
                }
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(respond: response.data!)
        }
    }
}