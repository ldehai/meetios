//
//  WordDetailViewController.swift
//  MeetSwift
//
//  Created by andy on 9/7/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class WordDetailViewController: UIViewController {

    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var popBg: UIView!
    @IBOutlet weak var wordName: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var detailTableView: UITableView!
    var word:WordModel!
    var wordArray:Results<WordModel>?
    var showMode:ShowMode!
    var currentIndex = 0
    @IBOutlet weak var knowBtn: UIButton!
    @IBOutlet weak var unknowBtn: UIButton!
    @IBAction func knowAction(sender: AnyObject) {
        self .getNextWord()
    }
    @IBAction func unknowAction(sender: AnyObject) {
        self .getNextWord()
    }
    
    func getNextWord(){
        print(currentIndex)
        if currentIndex + 1 == self.wordArray?.count  {
            self.popBg.hidden = true
            self.tipView.hidden = false
            
            //复习完成后通知服务器，可能有金币奖励
            MAPI .reviseComplete({ (respond) in
                let json = JSON(data:respond)
                let golden = json["data"]["golden"] .stringValue
            })
            return
        }
        
        currentIndex += 1
        
        let word = self.wordArray![currentIndex]
        wordName.text = word.word!.name
        MAPI.getWordDetail(word.id) { (respond) in
            let json = JSON(data:respond)
            let word = WordModel.fromJSON(json["data"])
            self.word = word
            
            self.detailTableView .reloadData()
        }
    }
    
    //不采集直接关闭窗口
    @IBAction func closeDlg(sender: AnyObject) {
        UIView .animateWithDuration(0.3, animations: {
            self.view.alpha = 0.0
        }) { (true) in
            
            self.dismissViewControllerAnimated(false){
                
            }
        }
    }
    
    //采集单词
    @IBAction func collectWordAction(sender: AnyObject) {
        UIView .animateWithDuration(0.3, animations: {
            self.view.alpha = 0.0
            }) { (true) in
                if self.showMode == ShowMode.Collect {
                    //采集
                    let appDelegate = UIApplication .sharedApplication().delegate as! AppDelegate
                    MAPI.collectWord(self.word.word!.id,
                                     lon: (self.word.word?.lon)!,
                                     lat: (self.word.word?.lat)!,
                                     city:appDelegate.city) { (respond) in
                        let json = JSON(data:respond)
                        let errorCode = json["code"] .intValue
                        print(errorCode)
                        if errorCode == 0 {
                            let golden = json["data"]["golden"] .stringValue
                            let wordId = json["data"]["id"] .stringValue
                            let userDefault = NSUserDefaults .standardUserDefaults()
                            userDefault .setObject(wordId, forKey: "lastWordId")
                            
                            //保存到本地
                            let realm = try! Realm()
                            try! realm.write {
                                self.word.word?.own = 1
                                self.word.collectTime = NSDate()
                                realm.add(self.word, update: true)
                                
                                NSNotificationCenter .defaultCenter() .postNotificationName(NOTIFY_COLLECT_WORD, object:self, userInfo: ["wordId":self.word!.id])
                            }
                        }
                        else{
                            let msg = json["message"].stringValue
                            let alert = UIAlertView(title: "提醒", message: msg, delegate: nil, cancelButtonTitle: "好的")
                            alert .show()
                        }
                    }
                    
                    
                }
                
                self.dismissViewControllerAnimated(false){
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.6, alpha: 0.6)
        
        wordName.text = self.word.word!.name
        
        if word.sysExample.count == 0 {
            MAPI .getWordDetail(word.id, completion: { (respond) in
                let json = JSON(data:respond)
                let word = WordModel.fromJSON(json["data"])
                word?.word?.lat = (self.word.word?.lat)!
                word?.word?.lon = (self.word.word?.lon)!
                self.word = word
                
                //保存到本地
                let realm = try! Realm()
                try! realm.write {
                    self.word.word?.own = 1
                    self.word.collectTime = NSDate()
                    realm.add(self.word, update: true)
                }
                
                self.detailTableView .reloadData()
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if self.showMode != ShowMode.Collect{
            //准备调整界面
            self.view .setNeedsLayout()
            
            popBg .snp_updateConstraints { (make) in
                make.top.equalTo(20)
                make.left.right.bottom.equalTo(0)
            }
            
            //开始刷新界面
            UIView .animateWithDuration(0.3, animations: {
                self.view .layoutIfNeeded()
            }) { (true) in
                
                if self.showMode == ShowMode.Show {
                    self.confirmBtn .setTitle("好的", forState: UIControlState.Normal)
                    self.confirmBtn.hidden = false
                }
                else if self.showMode == ShowMode.Collect{
                    self.confirmBtn .setTitle("收了它", forState: UIControlState.Normal)
                    self.confirmBtn.hidden = false
                }
                else if self.showMode == ShowMode.Train{
                    self.confirmBtn.hidden = true
                    self.knowBtn.hidden = false
                    self.unknowBtn.hidden = false
                }
            }
        }
        else{
            self.confirmBtn .setTitle("收了它", forState: UIControlState.Normal)
            self.confirmBtn.hidden = false
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 0:
            return 1
        case 1:
            return word.sysExample.count
        case 2:
            return word.userExample.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        switch indexPath.section {
        case 0:
            return WordBasicCell .cellHeightForData((self.word.word)!)
        case 1:
            let sample = word.sysExample[indexPath.row]
            return WordSampleCell .contentHeight(sample)
        case 2:
            return 100
        default:
            return 100
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        switch section {
        case 0:
            return 0.1
        case 1:
            return 10.0
        case 2:
            return 10.0
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        switch section {
        case 0:
            return ""
        case 1:
            return "Meet例句"
        case 2:
            return "蜜友例句"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell: WordBasicCell = tableView.dequeueReusableCellWithIdentifier("WordBasicCell") as! WordBasicCell
        
        //单词释义
        if indexPath.section == 0 {
            let cell: WordBasicCell = tableView.dequeueReusableCellWithIdentifier("WordBasicCell") as! WordBasicCell

            cell.word = word.word
//            cell.pronunciation.text = word.word!.pronunc
//            cell.def_cn.text = word.word?.def_cn .htmlDecoded()
//            cell.def_en.text = word.word?.def_en .htmlDecoded()
            
            return cell
        }
        //系统例句
        else if indexPath.section == 1{
            let cell: WordSampleCell = tableView.dequeueReusableCellWithIdentifier("WordSampleCell") as! WordSampleCell
            let sample = word.sysExample[indexPath.row]
            cell.sentence.text = sample.content .htmlDecoded()
            cell.translate_cn.text = sample.translation .htmlDecoded()
            
            return cell
        }
        //密友例句
        else if indexPath.section == 2{
            let cell: WordSampleCell = tableView.dequeueReusableCellWithIdentifier("WordSampleCell") as! WordSampleCell
            let sample = word.userExample[indexPath.row]
            cell.sentence.text = sample.content
            cell.translate_cn.text = sample.translation
            
            return cell
        }
        
        return cell
    }
}
