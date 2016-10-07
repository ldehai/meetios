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

    @IBOutlet weak var trainBtn: UIButton!
    var wordArray:Results<WordModel>?
    
    @IBAction func trainAction(sender: AnyObject) {
        let word = self.wordArray![0]
        MAPI.getWordDetail(word.id) { (respond) in
            let json = JSON(data:respond)
            let word = WordModel.fromJSON(json["data"])
            
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let wordDetail:WordDetailViewController = storyboard.instantiateViewControllerWithIdentifier("WordDetailVC") as! WordDetailViewController
            wordDetail.word = word
            wordDetail.wordArray = self.wordArray
            wordDetail.showMode = ShowMode.Train
            wordDetail.modalPresentationStyle = UIModalPresentationStyle.Custom;
            self.presentViewController(wordDetail, animated: false, completion: nil)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "采集袋"
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.tintColor = UIColor .blackColor()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //查询当天采集的单词
        let yesterday = NSDate .today()
        let realm = try! Realm()
        self.wordArray = realm.objects(WordModel.self).filter("collectTime > %@",yesterday).sorted("collectTime")
        self.tableView .reloadData()
        
        if self.wordArray?.count == 0 {
            self.trainBtn.enabled = false
            self.trainBtn.backgroundColor = UIColor(hex: "9B9B9B", alpha: 1.0)
        }
    }

    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.wordArray?.count)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 65.0;
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
