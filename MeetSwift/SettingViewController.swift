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
    @IBAction func logout(_ sender: AnyObject) {
        let alert = UIAlertView(title: "提醒", message: "确定要退出登录吗?", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int){
        if buttonIndex == 1 {
            let userDefault = UserDefaults.standard
            userDefault .removeObject(forKey: "userId")
            userDefault .removeObject(forKey: "accessToken")
            userDefault .removeObject(forKey: "lastWordId")
            
            NotificationCenter.default .post(name: Notification.Name(rawValue: NOTIFY_LOGOUT_OK), object: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let footer = UIView(frame: CGRect.zero)//[[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.tableFooterView = footer
        
        logoutBtn.layer.cornerRadius = 5;
        logoutBtn.layer.borderColor = UIColor(hex: "7E62BE", alpha: 1.0)?.cgColor
        logoutBtn.layer.borderWidth = 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView .deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            break
        case 1:
            //写评论
            UIApplication.shared .openURL(URL(string:"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1145700018&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8")!)
            break
        default:
            break
        }
    }
}
