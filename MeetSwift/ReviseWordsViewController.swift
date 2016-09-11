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

class ReviseWordsViewController: UIViewController {

    var tableView:UITableView!
    var collectView:UICollectionView!
    var reviseBtn:UIButton!
    var wordArray:Results<WordModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        self.wordArray = realm.objects(WordModel.self)
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
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        let word = self.wordArray[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let wordDetail:WordDetailViewController = storyboard.instantiateViewControllerWithIdentifier("WordDetailVC") as! WordDetailViewController
        wordDetail.word = word
        self.navigationController?.pushViewController(wordDetail, animated: true)
    }
}
