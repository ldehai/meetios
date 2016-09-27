//
//  ReviseWordsViewController.swift
//  MeetSwift
//
//  Created by andy on 9/11/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SwiftyJSON
import Realm
import RealmSwift

class ReviseWordsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var collectView:UICollectionView!
    var reviseBtn:UIButton!
    var wordArray:Results<WordModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view .backgroundColor = UIColor .whiteColor()
        self.title = "我的单词库"
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.tintColor = UIColor .blackColor()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let realm = try! Realm()
        self.wordArray = realm.objects(WordModel.self)
        self.tableView .reloadData()
        
        let userDefault = NSUserDefaults .standardUserDefaults()
        var lastWordId: String? = userDefault .objectForKey("lastWordId") as? String
        if (lastWordId == nil) {
            lastWordId = ""
        }
        MAPI.getMyWords(lastWordId!) { (respond) in
            //解析返回的单词
//            print("JSON: \(respond)")
            let json = JSON(data:respond)
            print(json["errorCode"])
            
            let wordList = json["data"].array
            for item in wordList! {
                let word = WordModel.fromJSON(item)
                //保存到本地
                print("save word:\(word?.word?.name)")
                let realm = try! Realm()
                try! realm.write {
                    word!.word!.own = 1
                    realm.add(word!, update: true)
                }
            }
            
            let realm = try! Realm()
            self.wordArray = realm.objects(WordModel.self)
            if self.wordArray != nil{
                self.tableView .reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wordArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 60.0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "WordCell")
        
        let word = self.wordArray[indexPath.row]
        cell.textLabel?.text = word.word!.name
        cell.detailTextLabel?.text = word.word!.def_cn
//        
//        let word = self.wordArray![indexPath.row]
//        cell.name.text = word.word?.name
//        cell.pronunciation.text = word.word?.pronunc
//        cell.definition_en.text = word.word?.def_en
//        cell.definition_cn.text = word.word?.def_cn
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        let word = self.wordArray[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let wordDetail:WordDetailViewController = storyboard.instantiateViewControllerWithIdentifier("WordDetailVC") as! WordDetailViewController
        wordDetail.word = word
        wordDetail.showMode = ShowMode.Show;
        wordDetail.modalPresentationStyle = UIModalPresentationStyle.Custom;
        self.presentViewController(wordDetail, animated: false, completion: nil)
    }
}
