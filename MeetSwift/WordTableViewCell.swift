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
    var word:Word?{
        didSet{
            
            name.text = word?.name
            pronunciation.text = word?.pronunc
            definition_cn.text = word?.def_cn
            definition_en.text = word?.def_en
            
            name .sizeToFit()
            pronunciation .sizeToFit()
            definition_cn .sizeToFit()
            definition_en .sizeToFit()
        }
    }

    @IBAction func playVoice(sender: AnyObject) {
        NSNotificationCenter .defaultCenter() .postNotificationName(NOTIFY_PLAY_WORD_VOICE, object: word?.uk_audio)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
