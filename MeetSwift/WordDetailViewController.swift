//
//  WordDetailViewController.swift
//  MeetSwift
//
//  Created by andy on 9/7/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class WordDetailViewController: UIViewController {

    @IBOutlet weak var popBg: UIView!
    @IBOutlet weak var wordName: UILabel!
    @IBOutlet weak var detailTableView: UITableView!
    var word:WordModel!
    
    //关闭窗口
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
                
                MAPI.collectWord(self.word.word.id, lon: "1", lat: "2") { (respond) in
                    let json = JSON(data:respond)
                    print(json["errorCode"])
                }

                self.dismissViewControllerAnimated(false){
                    
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.6, alpha: 0.6)
//        self.detailTableView.backgroundColor = UIColor .whiteColor()
        
        wordName.text = self.word.word.name
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
        return 100.0;//Choose your custom row height
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
            
            cell.pronunciation.text = word.word.def_cn
            return cell
        }
        //系统例句
        else if indexPath.section == 1{
            let cell: WordSampleCell = tableView.dequeueReusableCellWithIdentifier("WordSampleCell") as! WordSampleCell
            let sample = word.sysExample[indexPath.row]
            cell.sentence.text = sample.content
            cell.translate_cn.text = sample.translation
            
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 3
    }

}
