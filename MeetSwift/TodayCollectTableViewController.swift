//
//  TodayCollectTableViewController.swift
//  MeetSwift
//
//  Created by andy on 9/8/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class TodayCollectTableViewController: UITableViewController {

    private var wordArray = [Word]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "采集袋"
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.tintColor = UIColor .blackColor()
        
        MAPI .getWordsTodayCollect { (respond) in
            let json = JSON(data:respond)
            let wordList = json["data"].array
            for item in wordList! {
                let word = Word.fromJSON(item)
                self.wordArray.append(word!)
            }
            
            self.tableView .reloadData()
        }
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return self.wordArray.count
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wordArray.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 60.0;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "WordCell")

        let word = self.wordArray[indexPath.row]
        cell.textLabel?.text = word.name
        cell.detailTextLabel?.text = word.def_cn

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        let word = self.wordArray[indexPath.row]
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
