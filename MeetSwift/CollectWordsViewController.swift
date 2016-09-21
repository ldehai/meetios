//
//  CollectWordsViewController.swift
//  MeetSwift
//
//  Created by andy on 8/24/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import RealmSwift
import FoursquareAPIClient

class CollectWordsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var boxTipView: UIButton!
    @IBOutlet weak var shopTipView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    lazy var wordArray = [Word]()
    var coordinate:CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    var bHaveLocation:Bool = false
    
    //今日采集
    @IBAction func myCollectAction(sender: AnyObject) {
//        let todayCollect = TodayCollectTableViewController()
//        self.navigationController!.pushViewController(todayCollect, animated: true)
    }
    
    //商店
    @IBAction func openStore(sender: AnyObject) {
    }
    
    //返回首页
    @IBAction func goHome(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController? .setNavigationBarHidden(true, animated: true);
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        self .refreshCollectCount()
        
        NSNotificationCenter .defaultCenter() .addObserver(self, selector: #selector(collectWord(_:)), name: NOTIFY_COLLECT_WORD, object: nil)
    }

    func collectWord(notify:NSNotification){
        let userInfo = notify.userInfo as! [String: AnyObject]
        let wordId = userInfo["wordId"] as! String
        
        let allAnnotations = self.mapView.annotations
        for annotation in allAnnotations {
            if let wordAnnotaion = annotation as? WordAnnotation {
                if wordAnnotaion.word!.id == wordId{
                    self.mapView.removeAnnotation(wordAnnotaion)
                    break
                }
            }
        }
        
        self .refreshCollectCount()
    }
    
    func refreshCollectCount(){
        //查询当天采集的单词
        let yesterday = NSDate .yesterday()
        let realm = try! Realm()
        let wordArray = realm.objects(WordModel.self).filter("collectTime > %@",yesterday)
        
        self.boxTipView .setTitle(String(wordArray.count), forState: UIControlState.Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        mapView.showsUserLocation = (status == .AuthorizedAlways)
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                if self.bHaveLocation == true{
                    return
                }
                
                let client = FoursquareAPIClient(clientId: "S1VSRLLNCHK3FVAFF4LHJC1Q5NKO534OAI5VCQ0C0UKNBQB1",
                    clientSecret: "JNJWCRFZAUXCYYMYNLL4TVWRKABL3AGKLX232SG21JDI52PZ")
                let lat:String = (locations.last?.coordinate.latitude.description)!
                let lon:String = (locations.last?.coordinate.longitude.description)!
                let parameter: [String: String] = [
                    "ll": lat + "," + lon,
                    "limit": "1",
                ];
                
                client.requestWithPath("venues/search", parameter: parameter) {
                    (data, error) in
                    
                    // parse the JSON with NSJSONSerialization or Lib like SwiftyJson
                    
                    // result: {"meta":{"code":200},"notifications":[{"...
                    print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                    
                    self.getNearByWords((locations.last?.coordinate)!)
                }
                
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func getNearByWords(coordinate:CLLocationCoordinate2D){
        if coordinate.latitude > 0 {
            locationManager.stopUpdatingLocation()
            bHaveLocation = true
        }
        
        mapView.centerCoordinate = coordinate
        
        let regionRadius: CLLocationDistance = 500
        let region = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(region, animated: true)
        
        self.wordArray.removeAll()
        MAPI.getWordsBy(String(format:"%f",(coordinate.longitude)), lat: String(format:"%f",(coordinate.latitude))) { (respond) in
            //解析返回的单词
            print("JSON: \(respond)")
            let json = JSON(data:respond)
            print(json["errorCode"])
            
            let wordList = json["data"].array
            for item in wordList! {
                let word = Word.fromJSON(item)
                self.wordArray.append(word!)
                
                let rand = Double(arc4random()%20)/1000.0
                let wordCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude + rand, longitude: coordinate.longitude + rand*2)
                let newAnnotation = WordAnnotation()
                newAnnotation.coordinate = wordCoordinate
                newAnnotation.title = word?.name
                newAnnotation.subtitle = word?.def_cn
                newAnnotation.word = word
                self.mapView.addAnnotation(newAnnotation)
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if let annotation = annotation as? WordAnnotation{
            let identifier = "annotation"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if pinView == nil {
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinView!.canShowCallout = true
                
                //大头针图标
                let index = annotation.word?.name.startIndex.advancedBy(1)
                let letter = annotation.word?.name.substringToIndex(index!)
                pinView?.image = self .drawLetterAnnotation(UIImage(named: "pin")!, letter: letter!)
                
                //点击后弹出视图左侧图标
//                let mugIconView = UIImageView(image: UIImage(named: "avatar"))
//                pinView!.leftCalloutAccessoryView = mugIconView
                
                //点击后弹出视图右侧按钮
                let calloutView = UIButton(type: UIButtonType.DetailDisclosure)// as UIView
                pinView!.rightCalloutAccessoryView = calloutView
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView){
        if let annotation = view.annotation as? WordAnnotation{
            let word = annotation.word
            
            //点击大头针时，获取单词详情保存到本地
            MAPI.getWordDetail(word!.id) { (respond) in
                let json = JSON(data:respond)
                let word = WordModel.fromJSON(json["data"])
                
//                let realm = try! Realm()
//                try! realm.write {
//                    realm.add(word!)
//                }
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        if let annotation = view.annotation as? WordAnnotation{
            let word = annotation.word
            let realm = try! Realm()
            let wordModel = realm.objects(WordModel.self).filter("id = '\(word?.id)'").first
            if wordModel == nil {
                MAPI.getWordDetail(word!.id) { (respond) in
                    let json = JSON(data:respond)
                    let word = WordModel.fromJSON(json["data"])
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let wordDetail:WordDetailViewController = storyboard.instantiateViewControllerWithIdentifier("WordDetailVC") as! WordDetailViewController
                    wordDetail.word = word
                    wordDetail.modalPresentationStyle = UIModalPresentationStyle.Custom;
                    self.presentViewController(wordDetail, animated: false, completion: nil)
                }
            }
            else{
                let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let wordDetail:WordDetailViewController = storyboard.instantiateViewControllerWithIdentifier("WordDetailVC") as! WordDetailViewController
                wordDetail.word = wordModel
                wordDetail.modalPresentationStyle = UIModalPresentationStyle.Custom;
                self.presentViewController(wordDetail, animated: false, completion: nil)
            }
        }
    }
    
    //把单词第一个字母叠加到大头针图片上
    func drawLetterAnnotation(image:UIImage,letter: String) -> UIImage {
        
        let width = image.size.width
        let height = image.size.height
        
        //绘制图片
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        // 设置绘制图片的起始点
        image.drawAtPoint(CGPoint(x: 0, y: 0))
        
        //设置字母的文字属性并绘制
        let textFontAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(25.0),
            NSForegroundColorAttributeName: UIColor .whiteColor()
        ]
        let rect = CGRectMake(10, 5, 30, 30)
        letter.uppercaseString.drawInRect(rect, withAttributes: textFontAttributes)

        //获取已经绘制好的图
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //结束绘制
        UIGraphicsEndImageContext()
        
        //返回已经绘制好的图片
        return resultImage
    }
}
