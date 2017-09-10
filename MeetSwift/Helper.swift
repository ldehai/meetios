//
//  Helper.swift
//  MeetSwift
//
//  Created by andy on 10/7/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit

class Helper: NSObject {
    
    //生成随机数
    class func randomInRange(_ range: Range<Int>) -> Int {
        let count = UInt32(range.upperBound - range.lowerBound)
        return  Int(arc4random_uniform(count)) + range.lowerBound
    }

}
