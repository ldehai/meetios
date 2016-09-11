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

class ViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var wordCountView: UIView!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var gradeImage: UIImageView!
    @IBOutlet weak var goldView: UIView!
    @IBOutlet weak var goldCountLable: UILabel!
    @IBOutlet weak var goldImage: UIImageView!
    
    @IBOutlet weak var reviseView: CircleProgressView!
    @IBOutlet weak var todayView: CircleProgressView!
    let locationManager = CLLocationManager()
    
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
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        todayView.circleColor = MainColor!
        todayView.backgroundColor = UIColor .clearColor()
        todayView.circleBorderWidth = 20
        todayView .update(60)
        todayView.userInteractionEnabled = true
        let gestureToday = UITapGestureRecognizer(target: self, action: #selector(openTodayPractice))
        todayView .addGestureRecognizer(gestureToday)
        
        reviseView.circleColor = MainColor!
        reviseView.backgroundColor = UIColor .clearColor()
        reviseView.circleBorderWidth = 20
        reviseView.update(80)
        reviseView.userInteractionEnabled = true
        let gestureRevise = UITapGestureRecognizer(target: self, action: #selector(openReviseWords))
        reviseView .addGestureRecognizer(gestureRevise)
    }
    
    func openTodayPractice(){
        let todayCollect = TodayCollectTableViewController()
        self.navigationController!.pushViewController(todayCollect, animated: true)
    }

    func openReviseWords(){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let ReviseWordsVC:ReviseWordsViewController = storyboard.instantiateViewControllerWithIdentifier("ReviseWordsVC") as! ReviseWordsViewController
        self.navigationController!.pushViewController(ReviseWordsVC, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    func openUserProfile(){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let userProfileVC:UserProfileViewController = storyboard.instantiateViewControllerWithIdentifier("UserProfileVC") as! UserProfileViewController
        self.navigationController!.pushViewController(userProfileVC, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
    }
}

