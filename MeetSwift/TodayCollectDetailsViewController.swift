//
//  TodayCollectDetailsViewController.swift
//  MeetSwift
//
//  Created by 夏雪 on 16/9/19.
//  Copyright © 2016年 AventLabs. All rights reserved.
//

import UIKit

class TodayCollectDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var bottomView:UIView!
   @IBOutlet weak var topView: UIView!
    var completeCloseBtnClick:(()->())!
    var lastFrame:CGRect? {
        didSet{
           // self.settupTopView()
            
        }
    }
//    var refresh:Bool?{
//        didSet{
//            self.topView.snp_updateConstraints { (make) in
//                make.top.equalTo(10)
//            }
//        }
//    }
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settupBottomView()
        
//        self.tableview.tableHeaderView = topView
        self.tableview.delegate = self
        self.tableview.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        switch section {
        case 0:
            return 40.0
        case 1:
            return 40.0
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        switch section {
      
        case 0:
            return "Meet例句"
        case 1:
            return "蜜友例句"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell: UITableViewCell = UITableViewCell.init(style:.Default, reuseIdentifier: "")
        if indexPath.section == 0{
            let cell: WordSampleCell = tableView.dequeueReusableCellWithIdentifier("WordSampleCell") as! WordSampleCell
//            let sample = word.sysExample[indexPath.row]
//            cell.sentence.text = sample.content
//            cell.translate_cn.text = sample.translation
//            
            return cell
        }
            //密友例句
        else if indexPath.section == 1{
            let cell: WordSampleCell = tableView.dequeueReusableCellWithIdentifier("WordSampleCell") as! WordSampleCell
//            let sample = word.userExample[indexPath.row]
//            cell.sentence.text = sample.content
//            cell.translate_cn.text = sample.translation
            
            return cell
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }

    @IBAction func closeBtnClick(sender: AnyObject) {
        self.completeCloseBtnClick()
    }
    func settupBottomView()  {
        bottomView = UIView()

        self.view.addSubview(bottomView)
        bottomView.snp_makeConstraints { (make) in
            make.top.equalTo(kDeviceheight)
            make.height.equalTo(100)
            make.left.right.equalTo(0)
        }
        
        let unskilledBtn = UIButton.init(type: .Custom)
        unskilledBtn.backgroundColor = UIColor.init(hex: "BA77FF")
        unskilledBtn.setTitle("不熟练", forState: .Normal)
        bottomView.addSubview(unskilledBtn)
        unskilledBtn.snp_makeConstraints { (make) in
            make.left.equalTo(30)
            make.bottom.equalTo(-15)
            make.size.equalTo(CGSizeMake(100, 30))
        }

      let unskilledLabel = settupLabel("3", fontSize: 13.0, color: UIColor.init(hex: "BA77FF"))
        bottomView.addSubview(unskilledLabel)
        unskilledLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(unskilledBtn.snp_leading)
            make.bottom.equalTo(unskilledBtn.snp_top)
        }
        let label =  settupLabel("不熟练", fontSize: 13.0, color: UIColor.init(hex: "9B9B9B"))
        bottomView.addSubview(label)
        label.snp_makeConstraints { (make) in
            make.top.equalTo(unskilledLabel.snp_top)
            make.left.equalTo(unskilledLabel.snp_right)
        }
        
        
        let skilledBtn = UIButton.init(type: .Custom)
        skilledBtn.backgroundColor = UIColor.init(hex: "2ECC71")
        skilledBtn.setTitle("熟练", forState: .Normal)
        bottomView.addSubview(skilledBtn)
        skilledBtn.snp_makeConstraints { (make) in
            make.right.equalTo(-30)
            make.bottom.equalTo(-15)
            make.size.equalTo(CGSizeMake(100, 30))
        }
        let remainingLabel = settupLabel("剩下20个", fontSize: 13.0, color: UIColor.init(hex: "9B9B9B"))
        
        bottomView.addSubview(remainingLabel)
        remainingLabel.snp_makeConstraints { (make) in
            make.trailing.equalTo(skilledBtn.snp_trailing)
            make.bottom.equalTo(skilledBtn.snp_top)
        }
        
    }
    
    func settupTopView() {
        
        topView = UIView()
        topView.frame = CGRectMake(0, 0, kDeviceWidth, self.lastFrame!.size.height)
        self.view .addSubview(topView)
        topView .snp_makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.right.equalTo(0)
            make.height.height.equalTo(self.lastFrame!.size.height)
        }
        
        let name = UILabel()
        name.text = "Park"
        topView.addSubview(name)
        name .snp_makeConstraints { (make) in
            make.left.right.top.equalTo(0)
         }
        let btn = UIButton.init(type: .Custom)
        btn.setImage(UIImage.init(imageLiteral: "close"), forState: .Normal)
        
        topView.addSubview(btn)
        btn.snp_makeConstraints { (make) in
            make.right.equalTo(-20)
            make.top.equalTo(0)
        }
        btn.addTarget(self, action:#selector(closeBtnClick), forControlEvents:.TouchUpInside)
        
       let pronunciation = UILabel()
        pronunciation.text = "Park"
        topView.addSubview(pronunciation)
        pronunciation .snp_makeConstraints { (make) in
           make.leading.equalTo(name.snp_leading)
           make.top.equalTo(name.snp_bottom).dividedBy(1.0)
        }
        
        let definition_en = UILabel()
        definition_en.text = "xxxxx"
        topView.addSubview(definition_en)
         definition_en.snp_makeConstraints { (make) in
            make.leading.equalTo(name.snp_leading)
            make.top.equalTo(pronunciation.snp_bottom).dividedBy(1.0)
        }
//        
//        @IBOutlet weak var pronunciation: UILabel!
//        @IBOutlet weak var definition: UILabel!
//        @IBOutlet weak var name: UILabel!
//        @IBOutlet weak var definition_en: UILabel!
//        @IBOutlet weak var definition_cn: UILabel!
        
        
    }
    
    
}
