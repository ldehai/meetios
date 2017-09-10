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
    
    class func cellHeightForData(_ word:Word) -> CGFloat{
        let width = kDeviceWidth - 100; // whatever your desired width is
        let def_cn = NSMutableString(string: word.def_cn)
        let rectdef_cn = def_cn .boundingRect(with: CGSize(width: width, height: 10000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: nil, context: nil)
        
        let def_en = NSMutableString(string: word.def_en)
        let rectdef_en = def_en .boundingRect(with: CGSize(width: width, height: 10000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: nil, context: nil)
        
        let lines = def_en .components(separatedBy: "\n")
        return rectdef_cn.size.height + rectdef_en.size.height + CGFloat(lines.count) * 20 + 50
    }
    
    @IBAction func playVoice(_ sender: AnyObject) {
        NotificationCenter.default .post(name: Notification.Name(rawValue: NOTIFY_PLAY_WORD_VOICE), object: word?.uk_audio)
    }
    @IBOutlet weak var def_en: UILabel!
    @IBOutlet weak var def_cn: UILabel!
    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet weak var pronunciation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
