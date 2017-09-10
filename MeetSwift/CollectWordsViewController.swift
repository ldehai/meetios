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
import SpriteKit
import SceneKit

class CollectWordsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var goldenCount: UILabel!
    @IBOutlet weak var gradeView: UIButton!
    @IBOutlet weak var gradeBtn: UIButton!
    @IBOutlet weak var wordCount: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var boxTipView: UIButton!
    @IBOutlet weak var shopTipView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    lazy var wordArray = [Word]()
    var coordinate:CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    var bHaveLocation:Bool = false
    var city:RecommendCity?
    var user:User?
    
    @IBOutlet weak var userView: UIView!

    //今日采集
    @IBAction func myCollectAction(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let ReviseWordsVC:TodayCollectTableViewController = storyboard.instantiateViewController(withIdentifier: "TodayCollectTableVC") as! TodayCollectTableViewController
        self.navigationController!.pushViewController(ReviseWordsVC, animated: true)
    }
    
    //商店
    @IBAction func openStore(_ sender: AnyObject) {
    }
    
    //返回首页
    @IBAction func goHome(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController? .setNavigationBarHidden(true, animated: true);
        NotificationCenter.default .addObserver(self, selector: #selector(loadWordList), name: NSNotification.Name(rawValue: NOTIFY_LOAD_WORDLIST), object: nil)
        
        //获取个人详情
        MAPI .getUserProfile(MAPI.userId()) { (respond) in
            let json = JSON(data:respond)
            self.user = User.fromJSON(json["data"])
            
            self.avatarImage .sd_setImage(with: URL(string:SRCBaseURL + self.user!.avatar!), placeholderImage: UIImage(named: "avatar"))
            self.wordCount.text = String(self.user!.wordcount)
            self.gradeBtn .setTitle(String(self.user!.grade), for: UIControlState())
            self.gradeBtn.layer.borderWidth = 1
            self.gradeBtn.layer.borderColor = UIColor.white.cgColor
            self.goldenCount.text = String(self.user!.golden)
        }

        MAPI .getRecommendCity { (respond) in
            let json = JSON(data:respond)
            self.city = RecommendCity.fromJSON(json["data"])

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let lat = ((appDelegate.lat) as NSString) .doubleValue
            let lon = ((appDelegate.lon) as NSString) .doubleValue
            
            let coordinate = CLLocationCoordinate2D (latitude: lat, longitude: lon)
            self.mapView.centerCoordinate = coordinate
            
            let regionRadius: CLLocationDistance = 1000
            let region = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
            self.mapView.setRegion(region, animated: false)
            
            self.getNearByWords(coordinate)
        }
        
        userView.isUserInteractionEnabled = true
        let gestureUserProfile = UITapGestureRecognizer(target: self, action: #selector(openUserProfile))
        userView .addGestureRecognizer(gestureUserProfile)
        
        self .refreshCollectCount()
        
        NotificationCenter.default .addObserver(self, selector: #selector(collectWord(_:)), name: NSNotification.Name(rawValue: NOTIFY_COLLECT_WORD), object: nil)
        NotificationCenter.default .addObserver(self, selector: #selector(refreshLocation), name: NSNotification.Name(rawValue: NOTIFY_REFRESH_LOCATION), object: nil)
    }

    func openUserProfile(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let userProfileVC:UserProfileViewController = storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileViewController
        userProfileVC.userId = MAPI .userId()
        self.navigationController!.pushViewController(userProfileVC, animated: true)
    }
    
//    func openUserProfile(){
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let userProfile:ViewController = storyboard.instantiateViewController(withIdentifier: "rootVC") as! ViewController
//        self.navigationController!.pushViewController(userProfile, animated: true)
//    }
    
    func refreshLocation(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let lat = ((appDelegate.lat) as NSString) .doubleValue
        let lon = ((appDelegate.lon) as NSString) .doubleValue
        
        let coordinate = CLLocationCoordinate2D (latitude: lat, longitude: lon)
        self.mapView.centerCoordinate = coordinate
        
        let regionRadius: CLLocationDistance = 1000
        let region = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        self.mapView.setRegion(region, animated: false)
        
        self.getNearByWords(coordinate)
    }
    
    func loadWordList(){
        let lat = ((self.city?.lat)! as NSString) .doubleValue
        let lon = ((self.city?.lon)! as NSString) .doubleValue
        
        let coordinate = CLLocationCoordinate2D (latitude: lat, longitude: lon)
        mapView.centerCoordinate = coordinate
        
        let regionRadius: CLLocationDistance = 1000
        let region = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(region, animated: false)
        
        self.getNearByWords(coordinate)
    }
    
    func collectWord(_ notify:Notification){
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
        let yesterday = Date()
        let realm = try! Realm()
        let wordArray = realm.objects(WordModel.self).filter("collectTime > %@",yesterday)
        
        self.boxTipView .setTitle(String(wordArray.count), for: UIControlState.normal)
        
        //查询所有采集的单词
        let allWordArray = realm.objects(WordModel.self)
        self.wordCount.text = String(allWordArray.count)
        
    }
//    
//    func animateGolden(){
//        let scene = SCNView(frame: CGRectMake(0, 0, kDeviceWidth, kDeviceheight))
//        let sprite = SceneKit(scene)
//        self.view .addSubview(sprite)
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        UIApplication.shared.isStatusBarHidden = true
        
    }
    
/*    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        if self.city == nil {
            mapView.showsUserLocation = (status == .AuthorizedAlways)
            locationManager.startUpdatingLocation()
        }
        else{
            let lat = ((self.city?.lat)! as NSString) .doubleValue
            let lon = ((self.city?.lon)! as NSString) .doubleValue
            mapView.setCenterCoordinate(CLLocationCoordinate2D (latitude: lat, longitude: lon) , animated: true)
        }
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
    */
    func getNearByWords(_ coordinate:CLLocationCoordinate2D){
        self.wordArray.removeAll()
        MAPI.getWordsBy(String(format:"%f",(coordinate.longitude)) as NSString, lat: String(format:"%f",(coordinate.latitude)) as NSString) { (respond) in
            //解析返回的单词
            print("JSON: \(respond)")
            let json = JSON(data:respond)
            print(json["errorCode"])
            let code = json["code"]
            if code == "1"{
                return
            }
            
            let annos = self.mapView .annotations
            self.mapView .removeAnnotations(annos)
            
            let wordList = json["data"].array
            for item in wordList! {
                let word = Word.fromJSON(item)
                self.wordArray.append(word!)
                
                let newAnnotation = WordAnnotation()
                newAnnotation.title = word?.name
                newAnnotation.subtitle = word?.def_cn
                
                //如果单词本身已经有坐标，就使用单词的坐标，否则就在当前位置随机生成一个坐标
                if word?.lat == "" || word?.lon == ""{
                    let randX = Double(self .randomInRange(-10..<11))/1000.0
                    let randY = Double(self .randomInRange(-15..<16))/1000.0
                    let wordCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude + randY, longitude: coordinate.longitude + randX)
                    word?.lat = String(wordCoordinate.latitude)
                    word?.lon = String(wordCoordinate.longitude)
                    newAnnotation.coordinate = wordCoordinate
                }
                else{
                    newAnnotation.coordinate = CLLocationCoordinate2D(latitude: Double((word?.lat)!)!, longitude: Double((word?.lon)!)!)
                }
                
                newAnnotation.word = word
                self.mapView.addAnnotation(newAnnotation)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if let annotation = annotation as? WordAnnotation{
            let identifier = "annotation"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if pinView == nil {
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinView!.canShowCallout = true
                
                //大头针图标
                let index = annotation.word?.name.characters.index((annotation.word?.name.startIndex)!, offsetBy: 1)
                let letter = annotation.word?.name.substring(to: index!)
                pinView?.image = self .drawLetterAnnotation(UIImage(named: "pin2")!, letter: letter!)
                
                //点击后弹出视图左侧图标
//                let mugIconView = UIImageView(image: UIImage(named: "avatar"))
//                pinView!.leftCalloutAccessoryView = mugIconView
                
                //点击后弹出视图右侧按钮
                let calloutView = UIButton(type: UIButtonType.detailDisclosure)// as UIView
                pinView!.rightCalloutAccessoryView = calloutView
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }
        
        return nil
    }
    
//    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView){
//        if let annotation = view.annotation as? WordAnnotation{
//            let word = annotation.word
//            
//            //点击大头针时，获取单词详情保存到本地
//            MAPI.getWordDetail(word!.id) { (respond) in
//                let json = JSON(data:respond)
//                let word = WordModel.fromJSON(json["data"])
//                
//            }
//        }
//    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        if let annotation = view.annotation as? WordAnnotation{
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let wordDetail:WordDetailViewController = storyboard.instantiateViewController(withIdentifier: "WordDetailVC") as! WordDetailViewController
            wordDetail.showMode = ShowMode.collect
            wordDetail.modalPresentationStyle = UIModalPresentationStyle.custom;
            
            let word = annotation.word
            let realm = try! Realm()
            let wordModel = realm.objects(WordModel.self).filter("id = '\(word?.id)'").first
            if wordModel == nil {
                MAPI.getWordDetail(word!.id) { (respond) in
                    let json = JSON(data:respond)
                    let newWord = WordModel.fromJSON(json["data"])
                    newWord?.word?.lon = (word?.lon)!
                    newWord?.word?.lat = (word?.lat)!
                    
                    wordDetail.word = newWord
                    self.present(wordDetail, animated: false, completion: nil)
                }
            }
            else{
                wordDetail.word = wordModel
                self.present(wordDetail, animated: false, completion: nil)
            }
        }
    }
    
    //把单词第一个字母叠加到大头针图片上
    func drawLetterAnnotation(_ image:UIImage,letter: String) -> UIImage {
        
        let width = image.size.width
        let height = image.size.height
        
        //绘制图片
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        // 设置绘制图片的起始点
        image.draw(at: CGPoint(x: 0, y: 0))
        
        //设置字母的文字属性并绘制
        let textFontAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 25.0),
            NSForegroundColorAttributeName: UIColor.white
        ]
        let rect = CGRect(x: 20, y: 15, width: 30, height: 30)
        letter.uppercased().draw(in: rect, withAttributes: textFontAttributes)

        //获取已经绘制好的图
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //结束绘制
        UIGraphicsEndImageContext()
        
        //返回已经绘制好的图片
        return resultImage!
    }
    
    //生成随机数
    func randomInRange(_ range: Range<Int>) -> Int {
        let count = UInt32(range.upperBound - range.lowerBound)
        return  Int(arc4random_uniform(count)) + range.lowerBound
    }
}
