//
//  StringExtension.swift
//  MeetSwift
//
//  Created by andy on 10/7/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit

extension String {
    func htmlDecoded()->String {
        
        guard (self != "") else { return self }
        
        var newStr = self
        
        let entities = [
            "&quot;"    : "\"",
            "&amp;"     : "&",
            "&apos;"    : "'",
            "&lt;"      : "<",
            "&gt;"      : ">",
            "&#39;"      : "'",
            ]
        
        for (name,value) in entities {
            newStr = newStr.replacingOccurrences(of: name, with: value)
        }
        return newStr
    }
}
