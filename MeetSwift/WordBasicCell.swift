//
//  WordBasicCell.swift
//  MeetSwift
//
//  Created by andy on 9/8/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit

class WordBasicCell: UITableViewCell {
    var word:Word?{
        didSet{
            guard let word = word else {
                return;
            }
            
            pronunciation.text = word.pronunc
            definition.text = word.def_cn
            
            pronunciation .sizeToFit()
            definition .sizeToFit()
        }
    }
    @IBAction func playVoice(sender: AnyObject) {
        NSNotificationCenter .defaultCenter() .postNotificationName(NOTIFY_PLAY_WORD_VOICE, object: word?.uk_audio)
    }
    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet weak var pronunciation: UILabel!
    @IBOutlet weak var definition: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
