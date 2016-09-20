//
//  TodayCollectTableViewController.swift
//  MeetSwift
//
//  Created by andy on 9/8/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SwiftyJSON
import Realm
import RealmSwift
import SwiftDate

class TodayCollectTableViewController: UITableViewController {

    var wordArray:Results<WordModel>?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "采集袋"
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.tintColor = UIColor .blackColor()
        
        //查询当天采集的单词
        let yesterday = NSDate .yesterday()
        let realm = try! Realm()
        self.wordArray = realm.objects(WordModel.self).filter("collectTime > %@",yesterday)
        self.tableView .reloadData()
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wordArray!.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 60.0;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "WordCell")

        let word = self.wordArray![indexPath.row]
        cell.textLabel?.text = word.word!.name
        cell.detailTextLabel?.text = word.word!.def_cn

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        let word = self.wordArray![indexPath.row]
        MAPI.getWordDetail(word.id) { (respond) in
            let json = JSON(data:respond)
            let word = WordModel.fromJSON(json["data"])
            
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let wordDetail:WordDetailViewController = storyboard.instantiateViewControllerWithIdentifier("WordDetailVC") as! WordDetailViewController
            wordDetail.word = word
            wordDetail.modalPresentationStyle = UIModalPresentationStyle.Custom;
            self.presentViewController(wordDetail, animated: false, completion: nil)
        }
    }
}
