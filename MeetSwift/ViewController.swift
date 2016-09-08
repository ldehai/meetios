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
    
    let locationManager = CLLocationManager()
    
    @IBAction func goCollect(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let collectVC:UIViewController = storyboard.instantiateViewControllerWithIdentifier("CollectWords")
        collectVC.modalPresentationStyle = UIModalPresentationStyle.FormSheet;
        self.presentViewController(collectVC, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        
        avatarImage.snp_makeConstraints { (make) in
            make.width.height.equalTo(60);
//            make.top.left.equalTo(15);
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
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    func openUserProfile(){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let userProfileVC:UserProfileViewController = storyboard.instantiateViewControllerWithIdentifier("UserProfileVC") as! UserProfileViewController
//        userProfileVC.modalPresentationStyle = UIModalPresentationStyle.FormSheet;
//        self.presentViewController(userProfileVC, animated: false, completion: nil)
        
        let nav = UINavigationController(rootViewController: userProfileVC)
        self.presentViewController(nav, animated: false, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
    }
}

