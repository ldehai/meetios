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

    class func cellHeightForData(word:Word) -> CGFloat{
        let width = kDeviceWidth - 100; // whatever your desired width is
        let def_cn = NSMutableString(string: word.def_cn)
        let rectdef_cn = def_cn .boundingRectWithSize(CGSizeMake(width, 10000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: nil, context: nil)
        
        let def_en = NSMutableString(string: word.def_en)
        let rectdef_en = def_en .boundingRectWithSize(CGSizeMake(width, 10000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: nil, context: nil)
        
        return rectdef_cn.size.height + rectdef_en.size.height + 40
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
