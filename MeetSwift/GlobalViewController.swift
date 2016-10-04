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
        self.navigationController?.navigationBar.tintColor = UIColor .blackColor()
        
        topTip .snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
//            make.top.equalTo(144)
        }
        topTip .sizeToFit()
        
        wordRankBtn .snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(topTip.snp_bottom).offset(5)
            make.right.equalTo(self.view.snp_centerX).offset(-5)
            make.height.equalTo(35)
        }
        
        moneyRankBtn .snp_makeConstraints { (make) in
            make.top.equalTo(topTip.snp_bottom).offset(5)
            make.left.equalTo(self.view.snp_centerX).offset(5)
            make.right.equalTo(-15)
            make.height.equalTo(35)
        }
        
        tableView .snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(5)
            make.top.equalTo(topTip.snp_bottom).offset(45)
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.userArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 100.0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "WordCell")
        
        let user = self.userArray[indexPath.row]
        cell.textLabel?.text = user.nickName
        cell.detailTextLabel?.text = String(user.wordcount)
        
        return cell
    }
}
