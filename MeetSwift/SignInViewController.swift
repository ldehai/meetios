//
//  SignInViewController.swift
//  MeetSwift
//
//  Created by andy on 9/9/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignInViewController: UIViewController {

    @IBOutlet weak var telField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBAction func signInAction(sender: AnyObject) {
        MAPI .signin(telField.text!, password: pwdField.text!) { (respond) in
            let json = JSON(data:respond)
            let userId = json["data"]["userid"].stringValue
            let accessToken = json["data"]["accesstoken"].stringValue
            
            let userDefault = NSUserDefaults .standardUserDefaults()
            userDefault .setObject(userId, forKey: "userId")
            userDefault .setObject(accessToken, forKey: "accessToken")
            
            NSNotificationCenter .defaultCenter() .postNotificationName(NOTIFY_LOGIN_OK, object: nil)
        }
    }
    @IBAction func signUpAction(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let signUpVC:SignUpViewController = storyboard.instantiateViewControllerWithIdentifier("SignUpVC") as! SignUpViewController
        
        self.navigationController!.pushViewController(signUpVC, animated: true)
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
