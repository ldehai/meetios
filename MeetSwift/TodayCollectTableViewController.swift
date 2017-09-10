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
    
    @IBAction func trainAction(_ sender: AnyObject) {
        let word = self.wordArray![0]
        MAPI.getWordDetail(word.id) { (respond) in
            let json = JSON(data:respond)
            let word = WordModel.fromJSON(json["data"])
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let wordDetail:WordDetailViewController = storyboard.instantiateViewController(withIdentifier: "WordDetailVC") as! WordDetailViewController
            wordDetail.word = word
            wordDetail.wordArray = self.wordArray
            wordDetail.showMode = ShowMode.train
            wordDetail.modalPresentationStyle = UIModalPresentationStyle.custom;
            self.present(wordDetail, animated: false, completion: nil)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "采集袋"
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //查询当天采集的单词
        let yesterday = Date()
        let realm = try! Realm()
        self.wordArray = realm.objects(WordModel.self).filter("collectTime > %@",yesterday).sorted(byProperty: "collectTime")
        self.tableView .reloadData()
        
        if self.wordArray?.count == 0 {
            self.trainBtn.isEnabled = false
            self.trainBtn.backgroundColor = UIColor(hex: "9B9B9B", alpha: 1.0)
        }
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.wordArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 65.0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodayCollectCellId", for: indexPath) as! WordTableViewCell
        
        let word = self.wordArray![indexPath.row]
        cell.word = word.word
//        cell.name.text = word.word?.name
//        cell.pronunciation.text = word.word?.pronunc
//        cell.definition_en.text = word.word?.def_en
//        cell.definition_cn.text = word.word?.def_cn
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView .deselectRow(at: indexPath, animated: true)
        
        let word = self.wordArray![indexPath.row]
        MAPI.getWordDetail(word.id) { (respond) in
            let json = JSON(data:respond)
            let word = WordModel.fromJSON(json["data"])
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let wordDetail:WordDetailViewController = storyboard.instantiateViewController(withIdentifier: "WordDetailVC") as! WordDetailViewController
            wordDetail.word = word
            wordDetail.showMode = ShowMode.show
            wordDetail.modalPresentationStyle = UIModalPresentationStyle.custom;
            self.present(wordDetail, animated: false, completion: nil)
        }
    }
}
