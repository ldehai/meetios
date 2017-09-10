//
//  RecommendCityViewController.swift
//  MeetSwift
//
//  Created by andy on 9/27/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SnapKit

class RecommendCityViewController: UIViewController,UIWebViewDelegate {

    var city:RecommendCity?
    @IBOutlet weak var webView: UIWebView!
    @IBAction func goAction(_ sender: AnyObject) {
        NotificationCenter.default .post(name: Notification.Name(rawValue: NOTIFY_LOAD_WORDLIST), object: nil)
        self.dismiss(animated: false){
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "推荐城市"
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.webView.scrollView .showsVerticalScrollIndicator = false
        self.webView.delegate = self

        guard city?.id == nil else{
            let url = URL(string:APIBase + "/recommcity/" + (city?.id)!)
            let request = URLRequest(url: url!)
            self.webView .loadRequest(request)
            
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
