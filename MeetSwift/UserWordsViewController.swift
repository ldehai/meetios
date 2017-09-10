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
        self.navigationController?.navigationBar.tintColor = UIColor.black
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
                self.wordArray?.insert(word!, at: 0)
            }
            
            self.tableView .reloadData()
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.wordArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "WordCell")
        
        let word = self.wordArray?[indexPath.row]
        cell.textLabel?.text = word?.word!.name
        cell.detailTextLabel?.text = word?.word!.def_cn .htmlDecoded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView .deselectRow(at: indexPath, animated: true)
        
        let word = self.wordArray?[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let wordDetail:WordDetailViewController = storyboard.instantiateViewController(withIdentifier: "WordDetailVC") as! WordDetailViewController
        wordDetail.word = word
        wordDetail.showMode = ShowMode.show;
        wordDetail.modalPresentationStyle = UIModalPresentationStyle.custom;
        self.present(wordDetail, animated: false, completion: nil)
    }
}
