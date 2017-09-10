//
//  SignUpViewController.swift
//  MeetSwift
//
//  Created by andy on 9/9/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SwiftyJSON
import Spring

class SignUpViewController: UIViewController {

    @IBOutlet weak var telField: SpringTextField!
    @IBOutlet weak var pwdField: SpringTextField!
//    @IBAction func getVerifyCode(sender: AnyObject) {
//        MAPI .getVerifyCode(telField.text!) { (respond) in
//            let json = JSON(data:respond)
//        }
//    }
//    @IBAction func signUpAction(sender: AnyObject) {
//        MAPI.signup(telField.text!,verifycode: verifyCodeField.text!,password: passwordField.text!,nickName: nickNameField.text!,lon: "0",lat: "0") { (respond) in
//            
//            let json = JSON(data:respond)
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注册"
        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool{
        
        if telField.text!.isEmpty {
            MBProgressHUD .showError("手机号码不能为空")
            return false
        }
        if pwdField.text!.isEmpty {
            MBProgressHUD .showError("密码不能为空")
            return false
        }
        
        let userDefault = UserDefaults.standard
        userDefault .set(telField.text!, forKey: "tel")
        userDefault .set(pwdField.text!, forKey: "pwd")
        
        return true
    }

}
