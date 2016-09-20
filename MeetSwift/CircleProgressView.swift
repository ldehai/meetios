//
//  CircleProgressView.swift
//  MeetSwift
//
//  Created by andy on 9/10/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit

class CircleProgressView: UIView {

    //一圈分100段
    let kCircleSegs:Double = 100
    
    //当前进度
    var currentProgress:Double = 50.0
    
    //当前进度
    var total:Int = 0
    
    //中间数字的颜色
    var numberColor = UIColor .blackColor()
    
    //中间数字的字体
    var numberFont = UIFont .systemFontOfSize(16)
    
    //圆弧进度条颜色
    var circleColor = UIColor .greenColor()
    
    //圆弧宽度
    var circleBorderWidth:CGFloat = 5.0
    
    //更新进度
    func update(progress:Double,total:Int){
        self.currentProgress = progress
        self.total = total
        self .setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        
        //圆弧中心线的半径
        let radius = CGRectGetWidth(rect)/2.0 - self.circleBorderWidth/2.0;
        
        //两个PI，就是360度
        let angleOffset = M_PI_2;
        
        //画圆弧进度条
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
        
        //进度条不满时，画剩下的圆弧
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
        
        //画中间显示的数字
        CGContextSetLineWidth(context, 1.0);
        let numberText = String(Int(self.total));
        let size: CGSize = numberText.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(16.0)])

        let textFontAttributes = [
            NSFontAttributeName: self.numberFont,
            NSForegroundColorAttributeName: self.numberColor
        ]
        
        numberText.drawInRect(CGRectInset(rect, (CGRectGetWidth(rect) - size.width)/2.0, (CGRectGetHeight(rect) - size.height)/2.0), withAttributes: textFontAttributes)
    }
}
