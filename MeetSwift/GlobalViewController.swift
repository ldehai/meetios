//
//  GlobalViewController.swift
//  MeetSwift
//
//  Created by andy on 9/10/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class GlobalViewController: UIViewController {

    @IBOutlet weak var topTip: UILabel!
    @IBOutlet weak var wordRankBtn: UIButton!
    @IBOutlet weak var moneyRankBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var userArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "全球排行榜"
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        topTip .snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        topTip .sizeToFit()
        
        wordRankBtn .snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(topTip.snp.bottom).offset(5)
            make.right.equalTo(self.view.snp.centerX).offset(-5)
            make.height.equalTo(35)
        }
        
        moneyRankBtn .snp.makeConstraints { (make) in
            make.top.equalTo(topTip.snp.bottom).offset(5)
            make.left.equalTo(self.view.snp.centerX).offset(5)
            make.right.equalTo(-15)
            make.height.equalTo(35)
        }
        
        tableView .snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(5)
            make.top.equalTo(topTip.snp.bottom).offset(45)
        }
        
        MAPI .getTopRankWorld { (respond) in
            let json = JSON(data:respond)
            let userList = json["data"].array
            if userList == nil
            {
                return
            }
            for item in userList! {
                let user = User.fromJSON(item)
                self.userArray.append(user!)
            }
            
            self.tableView .reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.userArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        return 70.0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        
        let cell: TopManCell = tableView.dequeueReusableCell(withIdentifier: "topmancell", for: indexPath) as! TopManCell
        
        let user = self.userArray[indexPath.row]
        cell.posBtn .setTitle(String(indexPath.row + 1), for: UIControlState())
        cell.nameLabel.text = user.nickName
        cell.wordCountLabel.text = String(user.wordcount)
        let random = Helper .randomInRange(1..<1000)
        cell.avatarImage .sd_setImage(with: URL(string:SRCBaseURL + user.avatar! + "?v=\(random)"), placeholderImage: UIImage(named: "avatar"))
        switch indexPath.row {
        case 0:
            cell.posBtn .setBackgroundImage(UIImage(named: "goldenLevel"), for: UIControlState())
        case 1:
            cell.posBtn .setBackgroundImage(UIImage(named: "silverLevel"), for: UIControlState())
        case 2:
            cell.posBtn .setBackgroundImage(UIImage(named: "copperLevel"), for: UIControlState())
            
        default:
            cell.posBtn .setBackgroundImage(nil, for: UIControlState())
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        tableView .deselectRow(at: indexPath, animated: true)
        
        let user = self.userArray[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let userProfileVC:UserProfileViewController = storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileViewController
        userProfileVC.userId = user.userId!
        self.navigationController!.pushViewController(userProfileVC, animated: true)
    }
}
