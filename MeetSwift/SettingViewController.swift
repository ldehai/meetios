//
//  SettingViewController.swift
//  MeetSwift
//
//  Created by andy on 10/7/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController,UIAlertViewDelegate {

    @IBOutlet weak var logoutBtn: UIButton!
    @IBAction func logout(sender: AnyObject) {
        let alert = UIAlertView(title: "提醒", message: "确定要退出登录吗?", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if buttonIndex == 1 {
            let userDefault = NSUserDefaults .standardUserDefaults()
            userDefault .removeObjectForKey("userId")
            userDefault .removeObjectForKey("accessToken")
            userDefault .removeObjectForKey("lastWordId")
            
            NSNotificationCenter .defaultCenter() .postNotificationName(NOTIFY_LOGOUT_OK, object: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let footer = UIView(frame: CGRectZero)//[[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.tableFooterView = footer
        
        logoutBtn.layer.cornerRadius = 5;
        logoutBtn.layer.borderColor = UIColor(hex: "7E62BE", alpha: 1.0)?.CGColor
        logoutBtn.layer.borderWidth = 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            break
        case 1:
            //写评论
            UIApplication .sharedApplication() .openURL(NSURL(string:"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1145700018&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8")!)
            break
        default:
            break
        }
    }
}
