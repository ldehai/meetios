//
//  SignInViewController.swift
//  MeetSwift
//
//  Created by andy on 9/9/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SwiftyJSON
import Spring

class SignInViewController: UIViewController {

    @IBOutlet weak var telField: SpringTextField!
    @IBOutlet weak var pwdField: SpringTextField!
    @IBAction func signInAction(_ sender: AnyObject) {
        if telField.text!.isEmpty {
            self.telField.animation = "pop"
            self.telField.curve = "spring"
            self.telField.duration = 0.5
            self.telField.animate()
            MBProgressHUD .showError("手机号码不能为空")
            return
        }
        if pwdField.text!.isEmpty {
            self.pwdField.animation = "pop"
            self.pwdField.curve = "spring"
            self.pwdField.duration = 0.5
            self.pwdField.animate()
            MBProgressHUD .showError("密码不能为空")
            return
        }
        MAPI .signin(telField.text!, password: pwdField.text!) { (respond) in
            let json = JSON(data:respond)
            let code = json["code"]
            if code != "0"{
                MBProgressHUD .showError("用户名或密码有误")
                return
            }
            self.telField.animation = "FadeOut"
            self.telField.curve = "easeIn"
            self.telField.duration = 1.0
            self.telField.animate()
            
            let userId = json["data"]["userid"].stringValue
            let accessToken = json["data"]["accesstoken"].stringValue
            
            let userDefault = UserDefaults .standard
            userDefault .set(userId, forKey: "userId")
            userDefault .set(accessToken, forKey: "accessToken")
        
            NotificationCenter .default .post(name: NSNotification.Name(rawValue: NOTIFY_LOGIN_OK), object: nil)
        }
    }
    @IBAction func signUpAction(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let signUpVC:SignUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
        
        self.navigationController!.pushViewController(signUpVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登录"
        self.navigationController?.navigationBar.isHidden = false
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
