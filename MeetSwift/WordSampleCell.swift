//
//  WordSampleCell.swift
//  MeetSwift
//
//  Created by andy on 9/8/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit

class WordSampleCell: UITableViewCell {

    @IBOutlet weak var sentence: UILabel!
    @IBOutlet weak var translate_cn: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func contentHeight(sample:SysExample)-> CGFloat{
        
        let width = kDeviceWidth - 100; // whatever your desired width is
        let content = NSMutableString(string: sample.content)
        let contentSize = content .boundingRectWithSize(CGSizeMake(width, 10000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: nil, context: nil)
        
        let translation = NSMutableString(string: sample.translation)
        let translationSize = translation .boundingRectWithSize(CGSizeMake(width, 10000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: nil, context: nil)
        
        return contentSize.size.height + translationSize.size.height + 40
    }
}
