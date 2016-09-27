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

class TodayCollectTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var wordArray:Results<WordModel>?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "采集袋"
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.tintColor = UIColor .blackColor()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //查询当天采集的单词
        let yesterday = NSDate .yesterday()
        let realm = try! Realm()
        self.wordArray = realm.objects(WordModel.self).filter("collectTime > %@",yesterday)
        self.tableView .reloadData()
    }

    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.wordArray?.count)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 120.0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: WordTableViewCell = tableView.dequeueReusableCellWithIdentifier("TodayCollectCellId", forIndexPath: indexPath) as! WordTableViewCell
        
        let word = self.wordArray![indexPath.row]
        cell.word = word.word
//        cell.name.text = word.word?.name
//        cell.pronunciation.text = word.word?.pronunc
//        cell.definition_en.text = word.word?.def_en
//        cell.definition_cn.text = word.word?.def_cn
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        let word = self.wordArray![indexPath.row]
        MAPI.getWordDetail(word.id) { (respond) in
            let json = JSON(data:respond)
            let word = WordModel.fromJSON(json["data"])
            
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let wordDetail:WordDetailViewController = storyboard.instantiateViewControllerWithIdentifier("WordDetailVC") as! WordDetailViewController
            wordDetail.word = word
            wordDetail.showMode = ShowMode.Show
            wordDetail.modalPresentationStyle = UIModalPresentationStyle.Custom;
            self.presentViewController(wordDetail, animated: false, completion: nil)
        }
    }
}
