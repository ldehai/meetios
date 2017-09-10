//
//  UserProfileCell.swift
//  MeetSwift
//
//  Created by andy on 9/8/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit

class UserProfileCell: UITableViewCell,UIActionSheetDelegate {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var wordcountLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var goldenLabel: UILabel!
    var avatarClick:(()->())?
    var wordClick:(()->())?
    
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
            
            if let image = UIImage(contentsOfFile: user.avatar!){
                avatarImageView.image = image
            }
            else{
                let random = Helper .randomInRange(1..<1000)
                avatarImageView .sd_setImage(with: URL(string:SRCBaseURL + self.user!.avatar! + "?v=\(random)"), placeholderImage: UIImage(named: "avatar"))
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(changeAvatar))
            avatarImageView .addGestureRecognizer(tap)
            avatarImageView.isUserInteractionEnabled = true
            
            let wordCountTap = UITapGestureRecognizer(target: self, action: #selector(wordCountClick))
            wordcountLabel .addGestureRecognizer(wordCountTap)
            wordcountLabel.isUserInteractionEnabled = true
        }
    }
    
    func changeAvatar(){
        guard let avatarClick = avatarClick else{
            return
        }
        avatarClick()
    }
    
    func wordCountClick(){
        guard let wordClick = wordClick else{
            return
        }
        wordClick()
    }
    
    override func awakeFromNib() {
    
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
