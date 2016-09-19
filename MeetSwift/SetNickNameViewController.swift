//
//  SetNickNameViewController.swift
//  MeetSwift
//
//  Created by andy on 9/19/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import Spring
import SwiftyJSON

class SetNickNameViewController: UIViewController {

    @IBOutlet weak var nickName: SpringTextField!
    @IBAction func startGame(sender: AnyObject) {
        if nickName.text!.isEmpty {
            MBProgressHUD .showError("取个昵称吧，没有名号怎么闯江湖！")
            return
        }
        
        let userDefault = NSUserDefaults .standardUserDefaults()
        let tel = userDefault .objectForKey("tel") as! String
        let pwd = userDefault .objectForKey("pwd") as! String
        let verifycode = userDefault .objectForKey("verifycode") as! String
        
        MAPI.signup(tel,verifycode: verifycode,password: pwd,nickName: nickName.text!,lon: "0",lat: "0") { (respond) in
            let json = JSON(data:respond)
            let code = json["code"]
            if code != "0"{
                MBProgressHUD .showError("注册失败:" + json["message"] .stringValue)
                return
            }
            
            MAPI .signin(tel, password: pwd) { (respond) in
                let json = JSON(data:respond)
                let code = json["code"]
                if code != "0"{
                    MBProgressHUD .showError("用户名或密码有误")
                    return
                }
                
                let userId = json["data"]["userid"].stringValue
                let accessToken = json["data"]["accesstoken"].stringValue
                
                let userDefault = NSUserDefaults .standardUserDefaults()
                userDefault .setObject(userId, forKey: "userId")
                userDefault .setObject(accessToken, forKey: "accessToken")
                
                NSNotificationCenter .defaultCenter() .postNotificationName(NOTIFY_LOGIN_OK, object: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
