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
        self.title = "我的单词库"
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //加载我的单词
        let realm = try! Realm()
        self.wordArray = realm.objects(WordModel.self)
        self.tableView .reloadData()
        
        let userDefault = UserDefaults.standard
        var lastWordId: String? = userDefault .object(forKey: "lastWordId") as? String
        if (lastWordId == nil) {
            lastWordId = ""
        }
        MAPI.getMyWords(lastWordId!) { (respond) in
            //解析返回的单词
            let json = JSON(data:respond)
            print(json["errorCode"])
            
            let wordList = json["data"].array
            if wordList == nil{
                return
            }
            for item in wordList! {
                let word = WordModel.fromJSON(item)
                //保存到本地
                print("save word:\(word?.word?.name)")
                let realm = try! Realm()
                try! realm.write {
                    word!.word!.own = 1
                    realm.add(word!, update: true)
                }
                
                let wordId = item["word"]["collectid"] .stringValue
                let userDefault = UserDefaults .standard
                userDefault .set(wordId, forKey: "lastWordId")
            }
            
            let realm = try! Realm()
            self.wordArray = realm.objects(WordModel.self)
            if self.wordArray != nil{
                self.tableView .reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wordArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "WordCell")
        
        let word = self.wordArray[indexPath.row]
        cell.textLabel?.text = word.word!.name
        cell.detailTextLabel?.text = word.word!.def_cn .htmlDecoded()

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView .deselectRow(at: indexPath, animated: true)
        
        let word = self.wordArray[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let wordDetail:WordDetailViewController = storyboard.instantiateViewController(withIdentifier: "WordDetailVC") as! WordDetailViewController
        wordDetail.word = word
        wordDetail.showMode = ShowMode.show;
        wordDetail.modalPresentationStyle = UIModalPresentationStyle.custom;
        self.present(wordDetail, animated: false, completion: nil)
    }
}
