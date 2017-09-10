//
//  TopManCell.swift
//  MeetSwift
//
//  Created by andy on 10/4/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit

class TopManCell: UITableViewCell {

    @IBOutlet weak var posBtn: UIButton!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var wordCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
