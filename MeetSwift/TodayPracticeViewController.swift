//
//  TodayPracticeViewController.swift
//  MeetSwift
//
//  Created by andy on 9/11/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit

class TodayPracticeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
/*
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
        cell.textLabel?.text = word.name
        cell.detailTextLabel?.text = word.def_cn
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
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
    }*/
}
