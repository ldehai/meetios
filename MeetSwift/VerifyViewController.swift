//
//  VerifyViewController.swift
//  MeetSwift
//
//  Created by andy on 9/19/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import Spring
import SwiftyJSON

class VerifyViewController: UIViewController {

    @IBOutlet weak var verifyCode: SpringTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        let userDefault = NSUserDefaults .standardUserDefaults()
        let tel = userDefault .objectForKey("tel") as! String
//        MAPI .getVerifyCode(tel) { (respond) in
//            let json = JSON(data:respond)
//            let code = json["code"]
//            if code == "0"{
//                MBProgressHUD .showError("验证码已经发出，请查收短信")
//                return
//            }
//            else{
//                MBProgressHUD .showError("发送短信失败")
//                return
//            }
//        }
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
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool{
        
        if verifyCode.text!.isEmpty {
            MBProgressHUD .showError("验证码要填哦")
            return false
        }
        
        let userDefault = NSUserDefaults .standardUserDefaults()
        let tel = userDefault .objectForKey("tel") as! String
        MAPI .verifyCode(tel, verifycode: verifyCode.text!) { (respond) in
            let json = JSON(data:respond)
            let code = json["code"]
            if code != "0"{
                MBProgressHUD .showError("验证码不正确")
                return
            }
        }
        
        userDefault .setObject(verifyCode.text!, forKey: "verifycode")
        return true
    }

}
