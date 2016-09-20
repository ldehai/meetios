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
    
    internal func contentHeight()-> CGFloat{
        sentence.numberOfLines = 0; // allows label to have as many lines as needed
        sentence .sizeToFit()
        
        translate_cn.numberOfLines = 0; // allows label to have as many lines as needed
        translate_cn .sizeToFit()
        
        return sentence.frame.height + translate_cn.frame.height
    }
}
