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
    @IBOutlet weak var nickName: UILabel!
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
    @IBAction func showTopManProfile(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let userProfileVC:UserProfileViewController = storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileViewController
        userProfileVC.userId = self.topManUserId
        self.navigationController!.pushViewController(userProfileVC, animated: true)
    }
    
    @IBAction func recommendCityAction(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let collectVC:CollectWordsViewController = storyboard.instantiateViewController(withIdentifier: "CollectWords") as! CollectWordsViewController
        collectVC.city = self.city
        collectVC.user = self.user
        let nav = UINavigationController(rootViewController: collectVC)
        nav.modalPresentationStyle = UIModalPresentationStyle.formSheet;
        self.present(nav, animated: false, completion: nil)
    }
    
    @IBAction func topContributerAction(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let topContributer:TopContributerViewController = storyboard.instantiateViewController(withIdentifier: "topContributerVC") as! TopContributerViewController
        self.navigationController!.pushViewController(topContributer, animated: true)
    }
    
    @IBAction func globalRankAction(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let globalRankVC:GlobalViewController = storyboard.instantiateViewController(withIdentifier: "globalRankVC") as! GlobalViewController
        self.navigationController!.pushViewController(globalRankVC, animated: true)
    }
    @IBAction func goCollect(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: false)
//        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        let collectVC:CollectWordsViewController = storyboard.instantiateViewControllerWithIdentifier("CollectWords") as! CollectWordsViewController
//        collectVC.user = self.user
//        let nav = UINavigationController(rootViewController: collectVC)
//        nav.modalPresentationStyle = UIModalPresentationStyle.FormSheet;
//        self.presentViewController(nav, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        self.navigationController?.navigationBar.tintColor = UIColor.black
        UIApplication.shared.isStatusBarHidden = false
        
        self .setContraints()
        self .perform(#selector(self.getMyWords), with: nil, afterDelay: 0)
    }
    
    func refreshData(){
        //获取个人详情
        MAPI .getUserProfile(MAPI.userId()) { (respond) in
            let json = JSON(data:respond)
            self.user = User.fromJSON(json["data"])
            self.nickName.text = self.user?.nickName
            let random = Helper .randomInRange(1..<1000)
            self.avatarImage .sd_setImage(with: URL(string:SRCBaseURL + self.user!.avatar! + "?v=\(random)"), placeholderImage: UIImage(named: "avatar"))
            self.wordCountLabel.text = String(self.user!.wordcount)
//            self.reviseView.update(Double(self.user!.wordcount + 1), total: 1)
            self.goldCountLable.text = String(self.user!.golden)
            self.gradeBtn .setTitle(String(self.user!.grade), for: UIControlState())
            self.gradeBtn.layer.borderWidth = 1
            self.gradeBtn.layer.borderColor = UIColor.white.cgColor
            
//            self.todayView.update(50.0, total: (self.user?.todaywords)!)
//            self.reviseView.update(50.0, total: (self.user?.wordcount)!)
            self.totalWordCount.text = "\(self.user!.wordcount)"
        }
        
        MAPI .getRecommendCity { (respond) in
            let json = JSON(data:respond)
            self.city = RecommendCity.fromJSON(json["data"])
            self.recommendCity .setTitle(self.city?.name, for: UIControlState())
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
                self.topManAvatar .sd_setImage(with: URL(string:SRCBaseURL + user.avatar!), placeholderImage: UIImage(named: "avatar"))
                
                self.topMan .addTarget(self, action: #selector(self.showTopManProfile(_:)), for: UIControlEvents.touchUpInside)
                
                self.topManAvatar.isUserInteractionEnabled = true
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self.showTopManProfile(_:)))
                self.topManAvatar .addGestureRecognizer(gesture)
            }
        }
    }
    
    func getMyWords(){
        let userDefault = UserDefaults.standard
        var lastWordId: String? = userDefault .object(forKey: "lastWordId") as? String
        if (lastWordId == nil) {
            lastWordId = ""
        }
        MAPI.getMyWords(lastWordId!) { (respond) in
            //解析返回的单词
            print("JSON: \(respond)")
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
                let userDefault = UserDefaults .standard
                userDefault .set(wordId, forKey: "lastWordId")
            }
            
            self .refreshCollectCount()
        }
    }
    
    func refreshCollectCount(){
        //查询当天采集的单词
        let yesterday = Date()
        let realm = try! Realm()
        let wordArray = realm.objects(WordModel.self).filter("collectTime > %@",yesterday)
        self.todayWordCount.text = String(wordArray.count)
//        self.todayView.update(50.0, total: wordArray.count)
    }
    
    func setContraints(){
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
        
        //每日精进
//        todayView.circleColor = MainColor!
        todayView.backgroundColor = UIColor.clear
        todayView.layer.cornerRadius = 50
        todayView.layer.borderColor = UIColor(hex: "4A4A4A", alpha: 0.6)! .cgColor
        todayView.layer.borderWidth = 1
//        todayView.circleBorderWidth = 20
//        todayView .update(60,total: 100)
        todayView.isUserInteractionEnabled = true
        let gestureToday = UITapGestureRecognizer(target: self, action: #selector(openTodayPractice))
        todayView .addGestureRecognizer(gestureToday)
        
        //温故知新
//        reviseView.circleColor = MainColor!
        reviseView.backgroundColor = UIColor.clear
        reviseView.layer.cornerRadius = 50
        reviseView.layer.borderColor = UIColor(hex: "4A4A4A", alpha: 0.6)! .cgColor
        reviseView.layer.borderWidth = 1

//        reviseView.circleBorderWidth = 20
//        reviseView.update(80,total: 100)
        reviseView.isUserInteractionEnabled = true
        let gestureRevise = UITapGestureRecognizer(target: self, action: #selector(openReviseWords))
        reviseView .addGestureRecognizer(gestureRevise)
        
        avatarImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(60);
        };
        avatarImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openUserProfile))
        avatarImage .addGestureRecognizer(gesture)
        wordCountView.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarImage);
            make.top.equalTo(avatarImage.snp.centerY);
        }
        gradeBtn .addTarget(self, action: #selector(openUserProfile), for: UIControlEvents.touchUpInside)
        
        goldView .snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.centerX).offset(30)
        }
        
        todayView .snp.makeConstraints { (make) in
            make.right.equalTo(self.view.snp.centerX).offset(-30)
        }
        reviseView .snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.centerX).offset(30)
        }
        
        topMan .snp.makeConstraints { (make) in
            //make.right.equalTo(self.view.snp_centerX)
            make.right.equalTo(self.view.snp.centerX).offset(-30)
        }
        recommendCity .snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.centerX).offset(30)
        }
        topContribute .snp.makeConstraints { (make) in
            make.right.equalTo(self.view.snp.centerX).offset(-30)
        }
        topWorld .snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.centerX).offset(30)
        }
    }
    
    func openTodayPractice(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let ReviseWordsVC:TodayCollectTableViewController = storyboard.instantiateViewController(withIdentifier: "TodayCollectTableVC") as! TodayCollectTableViewController
        self.navigationController!.pushViewController(ReviseWordsVC, animated: true)
    }

    func openReviseWords(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let ReviseWordsVC:ReviseWordsViewController = storyboard.instantiateViewController(withIdentifier: "ReviseWordsVC") as! ReviseWordsViewController
        self.navigationController!.pushViewController(ReviseWordsVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        UIApplication.shared.isStatusBarHidden = false
        
        self .refreshData()
        self .refreshCollectCount()
    }
    
    func openUserProfile(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let userProfileVC:UserProfileViewController = storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileViewController
        userProfileVC.userId = MAPI .userId()
        self.navigationController!.pushViewController(userProfileVC, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
    }
}

