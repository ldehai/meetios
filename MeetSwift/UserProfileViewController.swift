//
//  UserProfileViewController.swift
//  MeetSwift
//
//  Created by andy on 9/8/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var user:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人中心"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        MAPI .getUserProfile { (respond) in
            let json = JSON(data:respond)
            self.user = User.fromJSON(json["data"])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 350.0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UserProfileCell = tableView .dequeueReusableCellWithIdentifier("UserProfileCell") as! UserProfileCell
        cell.user = self.user
//        cell.textLabel?.text = word.name
//        cell.detailTextLabel?.text = word.def_cn
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}
