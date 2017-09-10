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
    var numberColor = UIColor.black
    
    //中间数字的字体
    var numberFont = UIFont .systemFont(ofSize: 16)
    
    //圆弧进度条颜色
    var circleColor = UIColor.green
    
    //圆弧宽度
    var circleBorderWidth:CGFloat = 5.0
    
    //更新进度
    func update(_ progress:Double,total:Int){
        self.currentProgress = progress
        self.total = total
        self .setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        
        //圆弧中心线的半径
        let radius = rect.width/2.0 - self.circleBorderWidth/2.0;
        
        //两个PI，就是360度
        let angleOffset = M_PI_2;
        
        //画圆弧进度条
        context?.setLineWidth(self.circleBorderWidth);
        context?.beginPath();
        let rectCenter = CGPoint(x:rect.midX, y:rect.midY)
        context?.addArc(center: rectCenter, radius: radius,
                    startAngle: CGFloat(self.currentProgress/kCircleSegs*M_PI*2 - angleOffset), endAngle: 0, clockwise: false)
//        context?.addArc(tangent1End: CGPoint(rect.midX, rect.midY), tangent2End: CGPoint(CGFloat(self.currentProgress/kCircleSegs*M_PI*2 - angleOffset),0), radius: radius)
//        CGContextAddArc(context,
//                        rect.midX, rect.midY,
//                        radius,
//                        CGFloat(-angleOffset),
//                        CGFloat(self.currentProgress/kCircleSegs*M_PI*2 - angleOffset),
//                        0);
        
        context?.setStrokeColor(self.circleColor.cgColor);
        context?.strokePath();
        
        //进度条不满时，画剩下的圆弧
        if (self.currentProgress != kCircleSegs) {
            let rectCenter = CGPoint(x:rect.midX, y:rect.midY)
            context?.addArc(center: rectCenter, radius: radius,
                            startAngle: CGFloat(self.currentProgress/kCircleSegs*M_PI*2 - angleOffset), endAngle: 0, clockwise: false)
//            CGContextAddArc(context,
//                            rect.midX, rect.midY,
//                            radius,
//                            CGFloat(self.currentProgress/kCircleSegs*M_PI*2 - angleOffset),
//                            CGFloat(-angleOffset),
//                            0);
            
            context?.setStrokeColor(UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0).cgColor)
            context?.strokePath();
        }
        
        //画中间显示的数字
        context?.setLineWidth(1.0);
        let numberText = String(Int(self.total));
        let size: CGSize = numberText.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)])

        let textFontAttributes = [
            NSFontAttributeName: self.numberFont,
            NSForegroundColorAttributeName: self.numberColor
        ] as [String : Any]
        
        numberText.draw(in: rect.insetBy(dx: (rect.width - size.width)/2.0, dy: (rect.height - size.height)/2.0), withAttributes: textFontAttributes)
    }
}
