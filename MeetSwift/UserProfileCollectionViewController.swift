//
//  UserProfileCollectionViewController.swift
//  MeetSwift
//
//  Created by 夏雪 on 16/9/13.
//  Copyright © 2016年 AventLabs. All rights reserved.
//

import UIKit
import SwiftyJSON

private let reuseIdentifier = "FootprintCellId"

private let space:CGFloat = 20.0


enum TabType {
    case TabTypeFootprint         // 足迹
    case TabTypeContribution      // 贡献
    case TabTypeLike              // 喜欢
};

class UserProfileCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    var currentTabType:TabType = TabType.TabTypeFootprint
    var user:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人中心"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.layout.headerReferenceSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 300)
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        MAPI .getUserProfile { (respond) in
            let json = JSON(data:respond)
            self.user = User.fromJSON(json["data"])
            self.collectionView!.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch currentTabType {
        case .TabTypeFootprint:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as!FootprintCell
            return cell
            
        case.TabTypeContribution:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WordContributionCellId", forIndexPath: indexPath) as!WordContributionCollectionViewCell
            cell.backgroundColor = UIColor.whiteColor()
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WordContributionCellId", forIndexPath: indexPath) as!WordContributionCollectionViewCell
            cell.backgroundColor = UIColor.greenColor()
            return cell
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let cell1 = UICollectionReusableView()
        if (kind == UICollectionElementKindSectionHeader) {
            
            let cell: UserProfileReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "UserProfileReusableViewId", forIndexPath: indexPath) as! UserProfileReusableView
            cell.user = self.user
            cell.completeTabClick = { tabType  in
                print(tabType)
                self.currentTabType = tabType
                self.collectionView?.reloadData()
            }
            return cell
        }
        return cell1
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        switch self.currentTabType {
        case .TabTypeFootprint:
            return CGSizeMake(150 , 100)
        default:
            return CGSizeMake(kDeviceWidth - 60, 150)
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        switch self.currentTabType {
        case .TabTypeFootprint:
            return UIEdgeInsetsMake(space, space, space, space)
        default:
            return UIEdgeInsetsMake(space, space, space, space)
        }
    }
    
}
