//
//  GuideViewController.swift
//  MeetSwift
//
//  Created by andy on 9/18/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController,UIScrollViewDelegate {
    var currentPage = 0
    var scrollView:UIScrollView?
    var pageControl:UIPageControl?
    
    @IBAction func openCollect(_ sender: AnyObject) {
        NotificationCenter.default .post(name: Notification.Name(rawValue: NOTIFY_OPEN_COLLECTION), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
        self.scrollView = UIScrollView(frame: self.view.frame)
        self.view .addSubview(self.scrollView!)
        self.scrollView?.snp_makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        self.view .sendSubview(toBack: self.scrollView!)
        
        let pageWidth = self.view.frame.size.width;
        let contentWidth = self.view.frame.size.width * 4;
        let contentHeight = self.view.frame.size.height*2/3;
        self.scrollView?.contentSize = CGSize(width: contentWidth, height: 0)
        self.scrollView?.showsHorizontalScrollIndicator = false
        self.scrollView?.showsVerticalScrollIndicator = false
        self.scrollView?.scrollsToTop = false
        self.scrollView?.isPagingEnabled = true
        self.scrollView?.delegate = self
        
        //图片用assets管理，支持不同尺寸的屏幕比较方便，代码只需要管使用的图片名称就好了
        let guideTip = ["采集单词很有趣，学习就像玩游戏",
                        "记忆曲线设计，自动复习计划，无需烦神",
                        "密友社区，贴身教练，学习不再寂寞空虚冷",
                        "多条记忆线索，想忘记都难：）"]
        for i in 1...4 {
            let guideImageName = "guide\(i)"
            let imageView = UIImageView(image: UIImage(named: guideImageName))
            imageView.contentMode = UIViewContentMode.center
            imageView.frame = CGRect(x: CGFloat(i-1)*pageWidth, y: 0, width: pageWidth, height: contentHeight)
            self.scrollView?.addSubview(imageView)
            
            let guideTipView = UILabel(frame: CGRect(x: CGFloat(i-1)*pageWidth, y: contentHeight, width: pageWidth, height: 40))
            guideTipView.backgroundColor = UIColor.clear
            guideTipView.text = guideTip[i-1]
            guideTipView.font = UIFont .systemFont(ofSize: 14)
            guideTipView.textAlignment = NSTextAlignment.center
            self.scrollView?.addSubview(guideTipView)
        }
        
        self.currentPage = 0;
        self.pageControl = UIPageControl()
        self.pageControl?.pageIndicatorTintColor = UIColor(hex: "DEE1E2", alpha: 0.4)
        self.pageControl?.currentPageIndicatorTintColor = UIColor(hex: "4A4A4A", alpha: 0.4)
        
        self.pageControl?.numberOfPages = 4
        self.pageControl?.currentPage = 0
        self.view .addSubview(self.pageControl!)
        self.pageControl?.snp_makeConstraints({ (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-115)
            make.size.equalTo(CGSize(width:100,height:40))
        })

        self.scrollView?.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        //初始设为隐藏，视图显示时加入动态显示的效果，显得比较平滑
        self.scrollView?.alpha = 0.0
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        UIView .animate(withDuration: 0.5, animations: { 
            self.scrollView?.alpha = 1.0
        }) 
    }
    
    func scrollViewDidEndDecelerating(_ scrollView:UIScrollView)
    {
        self.pageControl?.currentPage = Int(scrollView.contentOffset.x/UIScreen.main.bounds.size.width);
    }
}
