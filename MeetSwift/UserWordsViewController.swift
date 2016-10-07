//
//  UserWordsViewController.swift
//  MeetSwift
//
//  Created by andy on 10/7/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserWordsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var wordArray:[WordModel]? = [WordModel]()
    var user:User!
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(self.user.nickName!)的单词库"
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.tintColor = UIColor .blackColor()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //加载我的单词
        self.tableView .reloadData()
        
        MAPI.getUserWords(self.user.userId!) { (respond) in
            //解析返回的单词
            let json = JSON(data:respond)
            print(json["errorCode"])
            
            let wordList = json["data"].array
            if wordList == nil{
                return
            }
//            if self.wordArray == nil{
//                self.wordArray = NSMutableArray()
//            }
            for item in wordList! {
                let word = WordModel.fromJSON(item)
                self.wordArray?.insert(word!, atIndex: 0)
            }
            
            self.tableView .reloadData()
        }
    }
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.wordArray?.count)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 60.0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "WordCell")
        
        let word = self.wordArray?[indexPath.row]
        cell.textLabel?.text = word?.word!.name
        cell.detailTextLabel?.text = word?.word!.def_cn .htmlDecoded()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        let word = self.wordArray?[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let wordDetail:WordDetailViewController = storyboard.instantiateViewControllerWithIdentifier("WordDetailVC") as! WordDetailViewController
        wordDetail.word = word
        wordDetail.showMode = ShowMode.Show;
        wordDetail.modalPresentationStyle = UIModalPresentationStyle.Custom;
        self.presentViewController(wordDetail, animated: false, completion: nil)
    }
}
