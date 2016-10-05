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
        self.title = "个人中心"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        MAPI .getUserProfile(userId) { (respond) in
            let json = JSON(data:respond)
      
            self.user = User.fromJSON(json["data"])
            
            self.tableView .reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 350.0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: UserProfileCell = tableView .dequeueReusableCellWithIdentifier("UserProfileCell") as! UserProfileCell
            cell.user = self.user
            
            //只能修改本人的头像
            if self.userId == MAPI .userId() {
                cell.avatarClick = {Void in
                    let alert = UIActionSheet(title: "设置个性头像", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "拍照",otherButtonTitles:"从相册选择")
                    alert .showInView(self.view)
                }
            }
            
            return cell
            
        default:
            let cell:UITableViewCell = tableView .dequeueReusableCellWithIdentifier("normalcell")!
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        switch buttonIndex {
        case 0:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.showsCameraControls = true
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        case 2:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        default:
            return
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData = UIImagePNGRepresentation(image)! as NSData
        
        //save in photo album
        UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        
        //save in documents
        let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        let filePath = (documentsPath! as NSString).stringByAppendingPathComponent("avatar\(self.userId).png")
        imageData.writeToFile(filePath, atomically: true)
        
//        myImage.image = image
        self.user.avatar = filePath
        self.tableView .reloadData()
        
        MAPI .updateAvatar(filePath) { (respond) in
            let json = JSON(data:respond)
            
//            self.user = User.fromJSON(json["data"])
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>){
        if(error != nil){
            print("ERROR IMAGE \(error.debugDescription)")
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
