//
//  CommonView.swift
//  MeetSwift
//
//  Created by 夏雪 on 16/9/21.
//  Copyright © 2016年 AventLabs. All rights reserved.
//

import Foundation
import UIKit

 public func settupLabel(_ text:String,fontSize:CGFloat = 15.0,color:UIColor = UIColor.black) ->(UILabel) {
        let label = UILabel.init()
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = color
        return label
    }
