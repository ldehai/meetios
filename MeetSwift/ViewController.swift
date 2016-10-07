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
    var topManUserId = ""
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
    @IBOutlet weak var topManName: UILabel!
    @IBOutlet weak var topManAvatar: UIImageView!
    @IBOutlet weak var reviseView: UIView!
    @IBOutlet weak var todayView: UIView!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var totalWordCount: UILabel!
    @IBOutlet weak var todayWordCount: UILabel!
    @IBAction func showTopManProfile(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let userProfileVC:UserProfileViewController = storyboard.instantiateViewControllerWithIdentifier("UserProfileVC") as! UserProfileViewController
        userProfileVC.userId = self.topManUserId
        self.navigationController!.pushViewController(userProfileVC, animated: true)
    }
    
    @IBAction func recommendCityAction(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let collectVC:CollectWordsViewController = storyboard.instantiateViewControllerWithIdentifier("CollectWords") as! CollectWordsViewController
        collectVC.city = self.city
        let nav = UINavigationController(rootViewController: collectVC)
        nav.modalPresentationStyle = UIModalPresentationStyle.FormSheet;
        self.presentViewController(nav, animated: false, completion: nil)
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
        let collectVC:CollectWordsViewController = storyboard.instantiateViewControllerWithIdentifier("CollectWords") as! CollectWordsViewController
        collectVC.user = self.user
        let nav = UINavigationController(rootViewController: collectVC)
        nav.modalPresentationStyle = UIModalPresentationStyle.FormSheet;
        self.presentViewController(nav, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        self.navigationController?.navigationBar.tintColor = UIColor .blackColor()
        UIApplication.sharedApplication().statusBarHidden = false
        
        self .setContraints()
        self .performSelector(#selector(self.getMyWords), withObject: nil, afterDelay: 0)
        self .refreshData()
    }
    
    func refreshData(){
        //获取个人详情
        MAPI .getUserProfile(MAPI.userId()) { (respond) in
            let json = JSON(data:respond)
            self.user = User.fromJSON(json["data"])
            self.avatarImage .sd_setImageWithURL(NSURL(string:SRCBaseURL + self.user!.avatar!), placeholderImage: UIImage(named: "avatar"))
            self.wordCountLabel.text = String(self.user!.wordcount)
//            self.reviseView.update(Double(self.user!.wordcount + 1), total: 1)
            self.goldCountLable.text = String(self.user!.golden)
            self.gradeBtn .setTitle(String(self.user!.grade), forState: UIControlState.Normal)
            self.gradeBtn.layer.borderWidth = 1
            self.gradeBtn.layer.borderColor = UIColor .whiteColor().CGColor
            
//            self.todayView.update(50.0, total: (self.user?.todaywords)!)
//            self.reviseView.update(50.0, total: (self.user?.wordcount)!)
            self.totalWordCount.text = "\(self.user!.wordcount)"
        }
        
        MAPI .getRecommendCity { (respond) in
            let json = JSON(data:respond)
            self.city = RecommendCity.fromJSON(json["data"])
            self.recommendCity .setTitle(self.city?.name, forState: UIControlState.Normal)
        }
        
        MAPI .getTopRankWorld { (respond) in
            let json = JSON(data:respond)
            let userList = json["data"].array
            if userList == nil
            {
                return
            }
            let item = userList?[0]
            if let user = User.fromJSON((item)!){
                self.topManName.text = user.nickName
                self.topManUserId = user.userId!
                self.topManAvatar .sd_setImageWithURL(NSURL(string:SRCBaseURL + user.avatar!), placeholderImage: UIImage(named: "avatar"))
                
                self.topMan .addTarget(self, action: #selector(self.showTopManProfile(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                self.topManAvatar.userInteractionEnabled = true
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self.showTopManProfile(_:)))
                self.topManAvatar .addGestureRecognizer(gesture)
            }
        }
    }
    
    func getMyWords(){
        let userDefault = NSUserDefaults .standardUserDefaults()
        var lastWordId: String? = userDefault .objectForKey("lastWordId") as? String
        if (lastWordId == nil) {
            lastWordId = ""
        }
        MAPI.getMyWords(lastWordId!) { (respond) in
            //解析返回的单词
            //            print("JSON: \(respond)")
            let json = JSON(data:respond)
            print(json["errorCode"])
            
            let wordList = json["data"].array
            if wordList == nil{
                return
            }
            for item in wordList! {
                let word = WordModel.fromJSON(item)
                //保存到本地
                print("save word:\(word?.word?.name)")
                let realm = try! Realm()
                try! realm.write {
                    word!.word!.own = 1
                    realm.add(word!, update: true)
                }
                
                let wordId = item["word"]["collectid"] .stringValue
                let userDefault = NSUserDefaults .standardUserDefaults()
                userDefault .setObject(wordId, forKey: "lastWordId")
            }
            
            self .refreshCollectCount()
        }
    }
    
    func refreshCollectCount(){
        //查询当天采集的单词
        let yesterday = NSDate .today()
        let realm = try! Realm()
        let wordArray = realm.objects(WordModel.self).filter("collectTime > %@",yesterday)
        self.todayWordCount.text = String(wordArray.count)
//        self.todayView.update(50.0, total: wordArray.count)
    }
    
    func setContraints(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        //每日精进
//        todayView.circleColor = MainColor!
        todayView.backgroundColor = UIColor .clearColor()
        todayView.layer.cornerRadius = 50
        todayView.layer.borderColor = UIColor(hex: "4A4A4A", alpha: 0.6)! .CGColor
        todayView.layer.borderWidth = 1
//        todayView.circleBorderWidth = 20
//        todayView .update(60,total: 100)
        todayView.userInteractionEnabled = true
        let gestureToday = UITapGestureRecognizer(target: self, action: #selector(openTodayPractice))
        todayView .addGestureRecognizer(gestureToday)
        
        //温故知新
//        reviseView.circleColor = MainColor!
        reviseView.backgroundColor = UIColor .clearColor()
        reviseView.layer.cornerRadius = 50
        reviseView.layer.borderColor = UIColor(hex: "4A4A4A", alpha: 0.6)! .CGColor
        reviseView.layer.borderWidth = 1

//        reviseView.circleBorderWidth = 20
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
            //make.right.equalTo(self.view.snp_centerX)
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
        UIApplication.sharedApplication().statusBarHidden = false
        
        self .refreshData()
        self .refreshCollectCount()
    }
    
    func openUserProfile(){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let userProfileVC:UserProfileViewController = storyboard.instantiateViewControllerWithIdentifier("UserProfileVC") as! UserProfileViewController
        userProfileVC.userId = MAPI .userId()
        self.navigationController!.pushViewController(userProfileVC, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
    }
}

