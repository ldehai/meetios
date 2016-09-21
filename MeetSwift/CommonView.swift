//
//  CommonView.swift
//  MeetSwift
//
//  Created by 夏雪 on 16/9/21.
//  Copyright © 2016年 AventLabs. All rights reserved.
//

import Foundation
import UIKit

 public func settupLabel(text:String,fontSize:CGFloat = 15.0,color:UIColor = UIColor.blackColor()) ->(UILabel) {
        let label = UILabel.init()
        label.text = text
        label.font = UIFont.systemFontOfSize(fontSize)
        label.textColor = color
        return label
    }