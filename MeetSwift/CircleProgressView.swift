//
//  CircleProgressView.swift
//  MeetSwift
//
//  Created by andy on 9/10/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit

class CircleProgressView: UIView {

    let kCircleSegs:Double = 100
    var currentProgress:Double = 50.0
    var numberColor = UIColor .blackColor()
    var numberFont = UIFont .systemFontOfSize(16)
    
    var circleColor = UIColor .greenColor()
    var circleBorderWidth:CGFloat = 5.0
    
    func update(progress:Double){
        self.currentProgress = progress
        self .setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        
        let radius = CGRectGetWidth(rect)/2.0 - self.circleBorderWidth/2.0;
        let angleOffset = M_PI_2;
        
        CGContextSetLineWidth(context, self.circleBorderWidth);
        CGContextBeginPath(context);
        
        CGContextAddArc(context,
                        CGRectGetMidX(rect), CGRectGetMidY(rect),
                        radius,
                        CGFloat(-angleOffset),
                        CGFloat(self.currentProgress/kCircleSegs*M_PI*2 - angleOffset),
                        0);
        
        CGContextSetStrokeColorWithColor(context, self.circleColor.CGColor);
        CGContextStrokePath(context);
        
        if (self.currentProgress != kCircleSegs) {
            CGContextAddArc(context,
                            CGRectGetMidX(rect), CGRectGetMidY(rect),
                            radius,
                            CGFloat(self.currentProgress/kCircleSegs*M_PI*2 - angleOffset),
                            CGFloat(-angleOffset),
                            0);
            
            CGContextSetStrokeColorWithColor(context, UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0).CGColor)
            CGContextStrokePath(context);
        }
        
        CGContextSetLineWidth(context, 1.0);
        let numberText = String(Int(self.currentProgress));
        let size: CGSize = numberText.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(16.0)])

        let textFontAttributes = [
            NSFontAttributeName: self.numberFont,
            NSForegroundColorAttributeName: self.numberColor
        ]
        
        numberText.drawInRect(CGRectInset(rect, (CGRectGetWidth(rect) - size.width)/2.0, (CGRectGetHeight(rect) - size.height)/2.0), withAttributes: textFontAttributes)
    }
}
