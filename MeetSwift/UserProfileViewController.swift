//
//  UserProfileViewController.swift
//  MeetSwift
//
//  Created by andy on 9/8/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import UIKit
import SwiftyJSON
import MediaPlayer
import MobileCoreServices

class UserProfileViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var user:User!
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.userId == MAPI .userId(){
            self.title = "个人中心"
            
            let setBtn = UIButton(frame: CGRect(x: 0,y: 0,width: 20,height: 20))
            setBtn .setImage(UIImage(named: "setting"), for: UIControlState())
            setBtn .addTarget(self, action: #selector(self.openSetting), for: UIControlEvents.touchUpInside)
            let rightBtn = UIBarButtonItem(customView: setBtn)
            self.navigationItem.rightBarButtonItem = rightBtn
        }
        else{
            self.title = "密友资料"
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        MAPI .getUserProfile(userId) { (respond) in
            let json = JSON(data:respond)
      
            self.user = User.fromJSON(json["data"])
            
            self.tableView .reloadData()
        }
    }
    
    func openSetting(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let settingVC:SettingViewController = storyboard.instantiateViewController(withIdentifier: "SettingVC") as! SettingViewController
        self.navigationController!.pushViewController(settingVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        return 350.0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: UserProfileCell = tableView .dequeueReusableCell(withIdentifier: "UserProfileCell") as! UserProfileCell
            cell.user = self.user
            
            //只能修改本人的头像
            if self.userId == MAPI .userId() {
                cell.avatarClick = {Void in
                    let alert = UIActionSheet(title: "设置个性头像", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "拍照",otherButtonTitles:"从相册选择")
                    alert .show(in: self.view)
                }
            }
            
            if self.userId != MAPI.userId() {
                cell.wordClick = {Void in
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let userWordsVC:UserWordsViewController = storyboard.instantiateViewController(withIdentifier: "UserWordsVC") as! UserWordsViewController
                    userWordsVC.user = self.user
                    self.navigationController!.pushViewController(userWordsVC, animated: true)
                }
            }
            
            return cell
            
        default:
            let cell:UITableViewCell = tableView .dequeueReusableCell(withIdentifier: "normalcell")!
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        tableView .deselectRow(at: indexPath, animated: true)
        
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int){
        switch buttonIndex {
        case 0:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.showsCameraControls = true
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        case 2:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        default:
            return
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData = UIImagePNGRepresentation(image)! as Data
        
        //save in photo album
//        UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        
        //save in documents
        let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        let filePath = (documentsPath! as NSString).appendingPathComponent("avatar\(self.userId).png")
        try? imageData.write(to: URL(fileURLWithPath: filePath), options: [.atomic])
        
//        myImage.image = image
        self.user.avatar = filePath
        self.tableView .reloadData()
        
        MAPI .updateAvatar(filePath) { (respond) in
            let json = JSON(data:respond)
            
//            self.user = User.fromJSON(json["data"])
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSErrorPointer?, contextInfo: UnsafeRawPointer){
        if(error != nil){
            print("ERROR IMAGE \(error.debugDescription)")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
    }
}
