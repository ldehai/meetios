//
//  ViewController.swift
//  MeetSwift
//
//  Created by andy on 8/23/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation
import SwiftyJSON
import SDWebImage
import RealmSwift

class ViewController: UIViewController, CLLocationManagerDelegate{

    var user:User?
    var city:RecommendCity?
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var wordCountView: UIView!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var gradeBtn: UIButton!
    @IBOutlet weak var gradeImage: UIImageView!
    @IBOutlet weak var goldView: UIView!
    @IBOutlet weak var goldCountLable: UILabel!
    @IBOutlet weak var goldImage: UIImageView!
    @IBOutlet weak var topMan: UIButton!
    @IBOutlet weak var recommendCity: UIButton!
    @IBOutlet weak var topContribute: UIButton!
    @IBOutlet weak var topWorld: UIButton!
    
    @IBOutlet weak var reviseView: CircleProgressView!
    @IBOutlet weak var todayView: CircleProgressView!
    let locationManager = CLLocationManager()
    
    @IBAction func recommendCityAction(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let topContributer:RecommendCityViewController = storyboard.instantiateViewControllerWithIdentifier("recommendCityVC") as! RecommendCityViewController
        topContributer.city = self.city
        self.navigationController!.pushViewController(topContributer, animated: true)
    }
    
    @IBAction func topContributerAction(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let topContributer:TopContributerViewController = storyboard.instantiateViewControllerWithIdentifier("topContributerVC") as! TopContributerViewController
        self.navigationController!.pushViewController(topContributer, animated: true)
    }
    
    @IBAction func globalRankAction(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let globalRankVC:GlobalViewController = storyboard.instantiateViewControllerWithIdentifier("globalRankVC") as! GlobalViewController
        self.navigationController!.pushViewController(globalRankVC, animated: true)
    }
    @IBAction func goCollect(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let collectVC:UIViewController = storyboard.instantiateViewControllerWithIdentifier("CollectWords")
        let nav = UINavigationController(rootViewController: collectVC)
        nav.modalPresentationStyle = UIModalPresentationStyle.FormSheet;
        self.presentViewController(nav, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        self.navigationController?.navigationBar.tintColor = UIColor .blackColor()
        
        self .setContraints()
        
        //获取个人详情
        MAPI .getUserProfile { (respond) in
            let json = JSON(data:respond)
            self.user = User.fromJSON(json["data"])
            
            self.avatarImage .sd_setImageWithURL(NSURL(fileURLWithPath: SRCBaseURL + self.user!.avatar!), placeholderImage: UIImage(named: "avatar"))
            self.wordCountLabel.text = String(self.user!.wordcount)
            self.reviseView.update(Double(self.user!.wordcount + 1), total: 1)
            self.goldCountLable.text = String(self.user!.golden)
            self.gradeBtn .setTitle(String(self.user!.grade), forState: UIControlState.Normal)
            self.gradeBtn.layer.borderWidth = 1
            self.gradeBtn.layer.borderColor = UIColor .whiteColor().CGColor
            
            self.todayView.update(50.0, total: (self.user?.todaywords)!)
            self.reviseView.update(50.0, total: (self.user?.wordcount)!)
        }
        
        MAPI .getRecommendCity { (respond) in
            let json = JSON(data:respond)
            self.city = RecommendCity.fromJSON(json["data"])
            self.recommendCity .setTitle(self.city?.name, forState: UIControlState.Normal)
        }
    }
    
    func refreshCollectCount(){
        //查询当天采集的单词
        let yesterday = NSDate .yesterday()
        let realm = try! Realm()
        let wordArray = realm.objects(WordModel.self).filter("collectTime > %@",yesterday)
        
        self.todayView.update(50.0, total: wordArray.count)
    }
    
    func setContraints(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        //每日精进
        todayView.circleColor = MainColor!
        todayView.backgroundColor = UIColor .clearColor()
        todayView.circleBorderWidth = 20
        todayView .update(60,total: 100)
        todayView.userInteractionEnabled = true
        let gestureToday = UITapGestureRecognizer(target: self, action: #selector(openTodayPractice))
        todayView .addGestureRecognizer(gestureToday)
        
        //温故知新
        reviseView.circleColor = MainColor!
        reviseView.backgroundColor = UIColor .clearColor()
        reviseView.circleBorderWidth = 20
//        reviseView.update(80,total: 100)
        reviseView.userInteractionEnabled = true
        let gestureRevise = UITapGestureRecognizer(target: self, action: #selector(openReviseWords))
        reviseView .addGestureRecognizer(gestureRevise)
        
        avatarImage.snp_makeConstraints { (make) in
            make.width.height.equalTo(60);
        };
        avatarImage.userInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openUserProfile))
        avatarImage .addGestureRecognizer(gesture)
        wordCountView.snp_makeConstraints { (make) in
            make.leading.equalTo(avatarImage);
            make.top.equalTo(avatarImage.snp_centerY);
        }
        gradeBtn .addTarget(self, action: #selector(openUserProfile), forControlEvents: UIControlEvents.TouchUpInside)
        
        goldView .snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_centerX).offset(30)
        }
        
        todayView .snp_makeConstraints { (make) in
            make.right.equalTo(self.view.snp_centerX).offset(-30)
        }
        reviseView .snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_centerX).offset(30)
        }
        
        topMan .snp_makeConstraints { (make) in
            make.right.equalTo(self.view.snp_centerX).offset(-30)
        }
        recommendCity .snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_centerX).offset(30)
        }
        topContribute .snp_makeConstraints { (make) in
            make.right.equalTo(self.view.snp_centerX).offset(-30)
        }
        topWorld .snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_centerX).offset(30)
        }
    }
    
    func openTodayPractice(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let ReviseWordsVC:TodayCollectTableViewController = storyboard.instantiateViewControllerWithIdentifier("TodayCollectTableVC") as! TodayCollectTableViewController
        self.navigationController!.pushViewController(ReviseWordsVC, animated: true)
    }

    func openReviseWords(){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let ReviseWordsVC:ReviseWordsViewController = storyboard.instantiateViewControllerWithIdentifier("ReviseWordsVC") as! ReviseWordsViewController
        self.navigationController!.pushViewController(ReviseWordsVC, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self .refreshCollectCount()
    }
    
    func openUserProfile(){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        let userProfileVC:UserProfileViewController = storyboard.instantiateViewControllerWithIdentifier("UserProfileVC") as! UserProfileViewController
//        
       let userProfileVC:UserProfileCollectionViewController = storyboard.instantiateViewControllerWithIdentifier("UserProfileCollectionVC") as! UserProfileCollectionViewController  
        
        self.navigationController!.pushViewController(userProfileVC, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
    }
}

