//
//  ChatPTVC+extension.swift
//  CarBuddies
//
//  Created by MAC on 30/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import Foundation
import UIKit
import FTIndicator

extension ChatPTVC{
    func setUpNavigationBar(){
        //LeftSideView
        let navLeftView:UIView = UIView()
        navLeftView.frame = CGRect(x: 0, y: 10, width: 100, height: 50)
        //ImageView
        let imageView: UIImageView = UIImageView()
        imageView.frame = CGRect (x: 46, y: 6, width: 35, height: 35)
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named:"iconUser")
        navLeftView.addSubview(imageView)
        //Back buttion
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "back"), for: UIControlState())
        btnLeftMenu.addTarget(self, action: #selector(self.onClcikBack), for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 3, width: 44, height: 44)
        navLeftView.addSubview(btnLeftMenu)
        //Add navLeftView as navigatinview left bar item
        let barButton = UIBarButtonItem(customView: navLeftView)
        self.navigationItem.leftBarButtonItem = barButton
        //Back buttion
        let btnRightMenu: UIButton = UIButton()
        btnRightMenu.setImage(UIImage(named: "delete"), for: UIControlState())
        btnRightMenu.addTarget(self, action: #selector(self.deleteChat), for: UIControlEvents.touchUpInside)
        btnRightMenu.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
     
        let btnRightButton = UIBarButtonItem(customView: btnRightMenu)
        self.navigationItem.rightBarButtonItem = btnRightButton
        
        wsManager = WebserviceManager()
        guard let imageUrlString = otherUserImageUrl else {
            return
        }
        // self.activityIndicator.startAnimating()
        wsManager.downloadImage2(URL(string: imageUrlString), completionHandler: { (image) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                 //self.activityIndicator.stopAnimating()
                //self.userProfileBtn.setBackgroundImage(image, for: UIControlState.normal)
                imageView.image = image
                self.otherUserImge = image
                
            })
        })
    }
    func showActionSheet(){
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
            
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
            
        }
        // Add the actions
        picker?.allowsEditing = true
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            self .present(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(picker!, animated: true, completion: nil)
        }
        
    }
    //Navigation back button action
    func onClcikBack()
    {
        _ = self.navigationController?.popViewController(animated: false)
    }
    func deleteChat()
    {
        let alert = UIAlertController(title: "Delete Chat", message:"Are you sure you want to delete your chat?", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
        let cancelAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.prepareChatDelete()
        }
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        // Present the controller
        self.present(alert, animated: false, completion: nil)
    }
    
    func prepareChatDelete(){
        FTIndicator.showProgress(withMessage: "Requesting..")
        Message.deleteChatFunction(childIWantToRemove: firbaseKeyId!, completion: {(sucess)-> Void in
        if sucess{
            self.boolDeleteChat = true
            self.deleteInstaceFromServer()
            }
            
            
            
        })
        
    }
    func deleteInstaceFromServer(){
       self.wsManager.deleteChat(otherUserID!, completionHandler: { (success, message) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if success {
                    FTIndicator.dismissProgress()
                    FTIndicator.showProgress(withMessage: message)
                    
                    self.onClcikBack()
                    //LoginFlow
                    //self.pushToLoginScreen()
                } else {
                    FTIndicator.dismissProgress()
                    FTIndicator.showProgress(withMessage: message)
                    
                }
            });
        })
    }
}
