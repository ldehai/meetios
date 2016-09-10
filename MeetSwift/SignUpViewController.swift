//
//  SignUpViewController.swift
//  MeetSwift
//
//  Created by andy on 9/9/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignUpViewController: UIViewController {

    @IBOutlet weak var telField: UITextField!
    @IBOutlet weak var verifyCodeField: UITextField!
    @IBOutlet weak var getVerifyCodeBtn: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nickNameField: UITextField!
    @IBAction func getVerifyCode(sender: AnyObject) {
        MAPI .getVerifyCode(telField.text!) { (respond) in
            let json = JSON(data:respond)
        }
    }
    @IBAction func signUpAction(sender: AnyObject) {
        MAPI.signup(telField.text!,verifycode: verifyCodeField.text!,password: passwordField.text!,nickName: nickNameField.text!,lon: "0",lat: "0") { (respond) in
            
            let json = JSON(data:respond)
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
