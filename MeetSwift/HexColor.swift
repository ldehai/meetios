//
//  HexColor.swift
//  MeetSwift
//
//  Created by andy on 9/10/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit

extension NSObject {
    
    func callSelectorAsync(_ selector: Selector, object: AnyObject?, delay: TimeInterval) -> Timer {
        
        let timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: selector, userInfo: object, repeats: false)
        return timer
    }
    
    func callSelector(_ selector: Selector, object: AnyObject?, delay: TimeInterval) {
        
        let delay = delay * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            Thread.detachNewThreadSelector(selector, toTarget:self, with: object)
        })
    }
}

public extension UIColor {
    
    /**
     Define UIColor with hex color string.
     - parameter hex:   hex color string, just like #fff or #ffffff
     - parameter alpha: a number between 0 and 1
     - returns: UIColor
     */
    public convenience init?(hex: String, alpha: Float = 1.0) {
        
        if hex.range(of: "(^#?[0-9A-Fa-f]{6}$)|(^#?[0-9A-Fa-f]{3}$)", options: .regularExpression) == nil {
            self.init()
            return nil
        }
        
        var red: String
        var green: String
        var blue: String
        var hexString: String = hex
        
        // Check for hash and remove the hash
        if hexString.hasPrefix("#") {
            hexString = hexString.substring(from: hexString.characters.index(hexString.startIndex, offsetBy: 1))
        }
        
        // Deal with 3 character hex strings
        if hexString.characters.count == 3 {
            red = (hexString as NSString).substring(to: 1)
            green = (hexString as NSString).substring(with: NSMakeRange(1, 1))
            blue = (hexString as NSString).substring(from: 2)
            
            red += red
            green += green
            blue += blue
        } else {
            red = (hexString as NSString).substring(to: 2)
            green = (hexString as NSString).substring(with: NSMakeRange(2, 2))
            blue = (hexString as NSString).substring(from: 4)
        }
        
        var redInt: CUnsignedInt = 0
        var greenInt: CUnsignedInt = 0
        var blueInt: CUnsignedInt = 0
        
        Scanner(string: red).scanHexInt32(&redInt)
        Scanner(string: green).scanHexInt32(&greenInt)
        Scanner(string: blue).scanHexInt32(&blueInt)
        
        self.init(
            red: CGFloat(redInt) / 255.0,
            green: CGFloat(greenInt) / 255.0,
            blue: CGFloat(blueInt) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
}
