//
//  UserProfileCell.swift
//  MeetSwift
//
//  Created by andy on 9/8/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit

class UserProfileCell: UITableViewCell {

   
   
    var user: User? {
        didSet {
        
            guard let user = user else
            {
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
   @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var followerLabel: UILabel!
    
    @IBOutlet weak var wordcountLabel: UILabel!
    
    @IBOutlet weak var gradeLabel: UILabel!
    
    @IBOutlet weak var goldenLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
    
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
