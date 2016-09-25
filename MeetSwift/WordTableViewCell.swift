//
//  WordTableViewCell.swift
//  MeetSwift
//
//  Created by 夏雪 on 16/9/20.
//  Copyright © 2016年 AventLabs. All rights reserved.
//

import UIKit

class WordTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pronunciation: UILabel!
    @IBOutlet weak var definition_en: UILabel!
    @IBOutlet weak var definition_cn: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
