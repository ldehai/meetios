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

extension NSObject {
    
    func callSelectorAsync(selector: Selector, object: AnyObject?, delay: NSTimeInterval) -> NSTimer {
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: selector, userInfo: object, repeats: false)
        return timer
    }
    
    func callSelector(selector: Selector, object: AnyObject?, delay: NSTimeInterval) {
        
        let delay = delay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            NSThread.detachNewThreadSelector(selector, toTarget:self, withObject: object)
        })
    }
}

class CollectWordsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    var coordinate:CLLocationCoordinate2D?
    var bHaveLocation:Bool = false
    var wordArray = [Word]()
    
    @IBAction func myCollectAction(sender: AnyObject) {
        let todayCollect = TodayCollectTableViewController()
//        todayCollect.modalPresentationStyle = UIModalPresentationStyle.Custom;
        let nav = UINavigationController(rootViewController: todayCollect)
        self.presentViewController(nav, animated: false, completion: nil)
    }
    @IBAction func openStore(sender: AnyObject) {
    }
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func goHome(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController? .setNavigationBarHidden(false, animated: true);
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        MAPI.getWordsBy("1", lat: "2") { (respond) in
            print("JSON: \(respond)")
            let json = JSON(data:respond)
            
            let wordList = json["data"].array
            for item in wordList! {
                let word = Word.fromJSON(item)
                self.wordArray.append(word!)
            }
        }
        
        MAPI.getWordDetail("1") { (respond) in
            let json = JSON(data:respond)
            let word = WordModel.fromJSON(json["data"])
            
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let wordDetail:WordDetailViewController = storyboard.instantiateViewControllerWithIdentifier("WordDetailVC") as! WordDetailViewController
            wordDetail.word = word
            wordDetail.modalPresentationStyle = UIModalPresentationStyle.Custom;
            self.presentViewController(wordDetail, animated: false, completion: nil)
        }
        
//        MAPI.collectWord("1", lon: "1", lat: "2") { (respond) in
//            print("JSON: \(respond)")
//            let json = JSON(data:respond)
//            print(json["errorCode"])
//
//        }
//        MAPI.getWordsTodayCollect { (respond) in
//            print("JSON: \(respond)")
//            let json = JSON(data:respond)
//            print(json["errorCode"])
//
//        }
    }

    func goHomeAction(){
        self.dismissViewControllerAnimated(false, completion: nil)
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
                self.getNearByWords((locations.last?.coordinate)!)
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
        
        let regionRadius: CLLocationDistance = 1000
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate,
//                                                                  regionRadius * 2.0, regionRadius * 2.0)
//        mapView.setRegion(coordinateRegion, animated: true)
        let region = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(region, animated: true)
        
        MAPI.getWordsBy(String(format:"%f",(coordinate.longitude)), lat: String(format:"%f",(coordinate.latitude))) { (respond) in
            //解析返回的单词
            print("JSON: \(respond)")
            let json = JSON(data:respond)
            print(json["errorCode"])
            
            let wordList = json["data"].array
            for word in wordList! {
                print(word["content"])
                
                let wordCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude + 0.000001, longitude: coordinate.longitude + 0.000002)
                let newAnnotation = MKPointAnnotation()
                newAnnotation.coordinate = wordCoordinate
                newAnnotation.title = word["content"].stringValue
                newAnnotation.subtitle = ""
                self.mapView.addAnnotation(newAnnotation)
            }
        }
    }
    
//    func startUpdateLocation(){
//        locationManager.stopUpdatingLocation()
//        locationManager.startUpdatingLocation()
//    }
    
    //mapview delegate
//    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation){
//        coordinate = userLocation.coordinate
//        
//        MAPI.getWordsBy("", lat: "") { (respond) in
//            //解析返回的单词
//            print("JSON: \(respond)")
//            let json = JSON(data:respond)
//            print(json["errorCode"])
//        }
//    }
}
