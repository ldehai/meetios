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
    @IBAction func goAction(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let collectVC:CollectWordsViewController = storyboard.instantiateViewControllerWithIdentifier("CollectWords") as! CollectWordsViewController
        collectVC.city = city
        let nav = UINavigationController(rootViewController: collectVC)
        nav.modalPresentationStyle = UIModalPresentationStyle.FormSheet;
        self.presentViewController(nav, animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "推荐城市"
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.tintColor = UIColor .blackColor()
        
//        MAPI getreco
        guard city?.id == nil else{
            let url = NSURL(string:APIBase + "/recommcity/" + (city?.id)!)
            let request = NSURLRequest(URL: url!)
            self.webView .loadRequest(request)
            
            return
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
