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
        let userDefault = UserDefaults.standard
        if let token =  userDefault .string(forKey: "accessToken"){
            return token
        }
        else{
            return ""
        }
    }
    
    class func userId() -> String{
        let userDefault = UserDefaults.standard
        if let userId =  userDefault .string(forKey: "userId"){
            return userId
        }
        else{
            return ""
        }
    }
    
    //获取当前地点的可采集单词
    class func getWordsBy(
        _ lon:NSString,
        lat:NSString,
        completion: @escaping (_ respond :Data) ->())
    {
        let parameters = ["lat":lat,
                          "lon":lon,
                          "token":MAPI .accessToken(),
                          "tags":["商场","食物"]] as [String : Any];
        print(parameters)
        Alamofire.request(APIBase + "/word", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//        Alamofire.request(APIBase + "/word", parameters: parameters)
//        Alamofire.request(.POST, APIBase + "/word", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
                if let json = response.result.value {
                    print("JSON: \(json)")
                    completion(response.data!)
                }
                switch response.result {
                case .success:
                    completion(response.data!)
                    
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    //根据单词查询详情
    class func getWordDetail(
        _ wordId:String,
        completion: @escaping (_ respond :Data) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(APIBase + "/word/" + wordId, method: .post, parameters: parameters, encoding: JSONEncoding.default)
//        Alamofire.request(APIBase + "/word/" + wordId, parameters: parameters)
//        Alamofire.request(.POST, APIBase + "/word/" + wordId, parameters: parameters, encoding: .JSON)
            .responseString { response in
//                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
                
                let convertStr = MAPI .stringByRemovingControlCharacters(response.result.value!)
                completion(convertStr.data(using: String.Encoding.utf8)!)
        }
    }
    
    class func stringByRemovingControlCharacters(_ inputString:String) ->String
    {
        let mutable = NSMutableString(string: inputString)
        
        let controlChars = CharacterSet .newlines
        var range = mutable .rangeOfCharacter(from: controlChars)
        if range.location != NSNotFound
        {
            while range.location != NSNotFound {
                mutable .deleteCharacters(in: range)
                range = mutable .rangeOfCharacter(from: controlChars)
            }
        }
        
        return mutable as String;
    }
    
    //采集了一个单词
    class func collectWord(
        _ word:String,
        lon:String,
        lat:String,
        city:String,
        completion: @escaping (_ respond :Data) ->())
    {
        let parameters = ["lat":lat,
                          "lon":lon,
                          "token":MAPI .accessToken(),
                          "city":city];
        Alamofire.request(APIBase + "/collect/" + word, method: .post, parameters: parameters, encoding: JSONEncoding.default)

//        Alamofire.request(.POST, APIBase + "/collect/" + word, parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                completion(response.data!)
        }
    }

    //复习关闭
    class func reviseComplete(_ completion: @escaping (_ respond :Data) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(APIBase + "/revisecomplete", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                completion(response.data!)
        }
    }

    //获取当日采集的所有单词
    class func getWordsTodayCollect(_ completion: @escaping (_ respond :Data) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(APIBase + "/word/today_list", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//        Alamofire.request(.POST, APIBase + "/word/today_list", parameters: parameters, encoding: .JSON)
            .responseString { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                let convertStr = MAPI .stringByRemovingControlCharacters(response.result.value!)
                completion(convertStr.data(using: String.Encoding.utf8)!)
        }
    }
    
    //获取我的所有单词
    class func getMyWords(_ lastWordId:String,completion: @escaping (_ respond :Data) ->())
    {
        print("call MAPI.getMyWords")
        let parameters = ["token":MAPI .accessToken(),"lastWordId":lastWordId];
        Alamofire.request(APIBase + "/myword", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//        Alamofire.request(.POST, APIBase + "/myword", parameters: parameters, encoding: .JSON)
            .responseString { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                let convertStr = MAPI .stringByRemovingControlCharacters(response.result.value!)
                print("convert result:\(convertStr)")
                completion(convertStr.data(using: String.Encoding.utf8)!)
        }
    }
    
    //获取其他人的所有单词
    class func getUserWords(_ userId:String,completion: @escaping (_ respond :Data) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(APIBase + "/userword/" + userId, method: .post, parameters: parameters, encoding: JSONEncoding.default)
//        Alamofire.request(.POST, APIBase + "/userword/" + userId, parameters: parameters, encoding: .JSON)
            .responseString { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                let convertStr = MAPI .stringByRemovingControlCharacters(response.result.value!)
                print("convert result:\(convertStr)")
                completion(convertStr.data(using: String.Encoding.utf8)!)
        }
    }
    
    //获取我的个人信息
    class func getUserProfile(_ userId:String,completion: @escaping (_ respond :Data) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(APIBase + "/user/" + userId, method: .post, parameters: parameters, encoding: JSONEncoding.default)
//        Alamofire.request(.POST, APIBase + "/user/" + userId, parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(response.data!)
        }
    }

    //登录
    class func signin(_ tel:String,password:String,completion: @escaping (_ respond :Data) ->())
    {
        let parameters = ["tel":tel,"pwd":password];
        Alamofire.request(APIBase + "/signin", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//        Alamofire.request(.POST, APIBase + "/signin", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(response.data!)
        }
    }
    
    //注册
    class func signup(_ tel:String,
                      verifycode:String,
                      password:String,
                      nickName:String,
                      lon:String,
                      lat:String,
                      completion: @escaping (_ respond :Data) ->())
    {
        let parameters = ["tel":tel,
                          "verifycode":verifycode,
                          "pwd":password,
                          "nickname":nickName,
                          "lon":lon,
                          "lat":lat];
        Alamofire.request(APIBase + "/signup", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//        Alamofire.request(.POST, APIBase + "/signup", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(response.data!)
        }
    }
    
    //获取短信验证码
    class func getVerifyCode(_ tel:String, completion: @escaping (_ respond :Data) ->())
    {
        let parameters = ["tel":tel];
        Alamofire.request(APIBase + "/getverifycode", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//        Alamofire.request(.POST, APIBase + "/getverifycode", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(response.data!)
        }
    }
    
    //验证短信验证码
    class func verifyCode(_ tel:String,verifycode:String, completion: @escaping (_ respond :Data) ->())
    {
        let parameters = ["tel":tel,"verifycode":verifycode];
        Alamofire.request(APIBase + "/verifycode", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//        Alamofire.request(.POST, APIBase + "/verifycode", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(response.data!)
        }
    }
    
    //上传头像
    class func updateAvatar(_ image:String, completion: @escaping (_ respond :Data) ->())
    {
        let imageData = UIImagePNGRepresentation(UIImage(contentsOfFile: image)!)!

        let url = try! URLRequest(url: URL(string:APIBase .appending("/avatar/") .appending(MAPI .userId()))!, method: .post, headers: nil)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "image", fileName: "file.png", mimeType: "image/png")
        },
            with: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                        }
                        
                        completion(response.data!)
                    }
                    
                case .failure(_):
                    break
                    // failure block
                }
        }
        )
    }
    
    //推荐城市
    class func getRecommendCity(_ completion: @escaping (_ respond :Data) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(APIBase + "/recommendcity", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//        Alamofire.request(.POST, APIBase + "/recommendcity", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(response.data!)
        }
    }
    
    //贡献榜
    class func getTopContributer(_ completion: @escaping (_ respond :Data) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(APIBase + "/topcontributer", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//        Alamofire.request(.POST, APIBase + "/topcontributer", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(response.data!)
        }
    }
    
    //全球排行榜
    class func getTopRankWorld(_ completion: @escaping (_ respond :Data) ->())
    {
        let parameters = ["token":MAPI .accessToken()];
        Alamofire.request(APIBase + "/topworld", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//        Alamofire.request(.POST, APIBase + "/topworld", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                if response.result .isSuccess == false{
                    return
                }
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                completion(response.data!)
        }
    }
}
