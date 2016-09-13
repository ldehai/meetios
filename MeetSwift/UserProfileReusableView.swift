//
//  UserProfileReusableView.swift
//  MeetSwift
//
//  Created by 夏雪 on 16/9/13.
//  Copyright © 2016年 AventLabs. All rights reserved.
//  个人中心头部

import UIKit



class UserProfileReusableView: UICollectionReusableView {
 var completeTabClick:((TabType)->())?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var followerLabel: UILabel!
    
    @IBOutlet weak var wordcountLabel: UILabel!
    
    @IBOutlet weak var gradeLabel: UILabel!
    
    @IBOutlet weak var goldenLabel: UILabel!
    
    @IBOutlet weak var footprintBtn: UIButton!
    
   lazy var selectBtn:UIButton = UIButton.init(type:.Custom)

    var user: User? {
        didSet {
            guard let user = user else {
                return;
            }
            nicknameLabel.text = user.nickName
            followingLabel.text = "\(user.following)"
            followerLabel.text = "\(user.follower)"
            wordcountLabel.text = "\(user.wordcount)"
            gradeLabel.text = "\(user.grade)"
            goldenLabel.text = "\(user.golden)"
        }
    }
    
    @IBAction func tabBtnClick(sender: UIButton) {
        guard let completeTabClick = completeTabClick else{
            return
        }
        switch sender.tag {
        case 0:
            completeTabClick(TabType.TabTypeFootprint)
        case 1:
            completeTabClick(TabType.TabTypeContribution)
        default:
            completeTabClick(TabType.TabTypeLike)
        }
        selectBtn.selected = false
        sender.selected = true
        selectBtn = sender
    }
 
    override func awakeFromNib() {
        super.awakeFromNib()
        selectBtn = footprintBtn
        // Initialization code
    }
    
}
