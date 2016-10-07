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
            def_cn.text = word.def_cn .htmlDecoded()
            def_en.text = word.def_en .htmlDecoded()
            
            pronunciation .sizeToFit()
            def_cn .sizeToFit()
            def_en .sizeToFit()
        }
    }
    
    class func cellHeightForData(word:Word) -> CGFloat{
        let width = kDeviceWidth - 100; // whatever your desired width is
        let def_cn = NSMutableString(string: word.def_cn)
        let rectdef_cn = def_cn .boundingRectWithSize(CGSizeMake(width, 10000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: nil, context: nil)
        
        let def_en = NSMutableString(string: word.def_en)
        let rectdef_en = def_en .boundingRectWithSize(CGSizeMake(width, 10000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: nil, context: nil)
        
        let lines = def_en .componentsSeparatedByString("\n")
        return rectdef_cn.size.height + rectdef_en.size.height + CGFloat(lines.count) * 20 + 50
    }
    
    @IBAction func playVoice(sender: AnyObject) {
        NSNotificationCenter .defaultCenter() .postNotificationName(NOTIFY_PLAY_WORD_VOICE, object: word?.uk_audio)
    }
    @IBOutlet weak var def_en: UILabel!
    @IBOutlet weak var def_cn: UILabel!
    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet weak var pronunciation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
