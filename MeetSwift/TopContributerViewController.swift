//
//  TopContributerViewController.swift
//  MeetSwift
//
//  Created by andy on 9/10/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class TopContributerViewController: UIViewController {

    @IBOutlet weak var topTip: UILabel!
    @IBOutlet weak var tableView: UITableView!
    lazy var userArray = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "贡献榜"
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        topTip .sizeToFit()
        topTip .snp.makeConstraints { (make) in
            make.left.right.equalTo(15)
        }
        
        tableView .snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(5)
            make.top.equalTo(topTip.snp.bottom).offset(5)
        }
        
        MAPI .getTopContributer { (respond) in
            let json = JSON(data:respond)
            let userList = json["data"].array
            
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
        return 100.0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "WordCell")
        
        let user = self.userArray[indexPath.row]
        cell.textLabel?.text = user.nickName
        cell.detailTextLabel?.text = String(user.contributerWord)
        
        return cell
    }
}
