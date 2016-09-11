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

    lazy var wordArray = [Word]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        
        MAPI .getMyWords { (respond) in
            print("JSON: \(respond)")
            let json = JSON(data:respond)
            
            let wordList = json["data"].array
            for item in wordList! {
                let word = Word.fromJSON(item)
                self.wordArray.append(word!)
                
                try! realm.write {
                    realm.add(word!)
                }
            }
        }
    }
}
