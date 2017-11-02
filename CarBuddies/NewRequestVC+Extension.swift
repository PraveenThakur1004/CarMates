//
//  NewRequestVC+Extension.swift
//  CarBuddies
//[
//  Created by MAC on 10/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import  FTIndicator
extension NewRequestVC{
    //MARK:- SetUp Stepper to set time
    func setUpDetailView(){
        popUpDetailView.frame = self.view.bounds
        self.view.addSubview(popUpDetailView)
        // timeSetupView.fadeIn()
        self.popUpDetailView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.popUpDetailView.isOpaque = true
        // Initialization code
        messageView.layer.shadowOpacity = 0.2
        messageView.layer.shadowOffset = CGSize(width: 3, height: 3)
        messageView.layer.shadowRadius = 15.0
        messageView.layer.shadowColor = UIColor.darkGray.cgColor
        messageView.layer.cornerRadius = 2.0
        
       
        
    }
    func checkFirebaseData(_ item: NSDictionary){
        let value = self.setChatData(item)
        let user = item.object(forKey: "User") as? NSDictionary
        
        ChatData.uploadData(withValues: value ,toID: makeKey(senderId: user?.object(forKey: "id") as! String), completion: {(message) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                let request = item.object(forKey: "Request") as? NSDictionary
                let lastMessage = request?.object(forKey: "message")
                let message =   Message( content: lastMessage ?? "", time:CommonUtility.getCurrentDate(), isImage: false,fromID:user?.object(forKey: "id") as! String)
                Message.send(message: message, underId:self.makeKey(senderId: user?.object(forKey: "id") as! String), toId: Singleton.sharedInstance.user.id! , completion: {(sucess) -> Void in
                    if sucess{
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Slider", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "ID_ChatPTVC") as! ChatPTVC
                        vc.senderId = Singleton.sharedInstance.user.id
                        vc.senderDisplayName = Singleton.sharedInstance.user.name
                        vc.otherUserID = user?.object(forKey: "id") as? String
                        vc.otherUserName = user?.object(forKey: "name") as? String
                        vc.firbaseKeyId = self.makeKey(senderId: user?.object(forKey: "id") as! String)
                        vc.otherUserImageUrl = user?.object(forKey: "person_image") as? String
                        FTIndicator.dismissProgress()
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else{
                           FTIndicator.dismissProgress()
                        FTIndicator.showToastMessage("No chat found")
                        
                    }
                })
               
            })
            
        })
    }
    fileprivate func setChatData(_ data: NSDictionary) -> [String:Any]  {
        print("the data is \(data)")
        let item = data.object(forKey: "User") as? NSDictionary
        let request = data.object(forKey: "Request") as? NSDictionary
        let lastMessage = request?.object(forKey: "message")
        var user1ID :String?
        var user1Image:String?
        var user1Name:String?
        var user2ID : String?
        var user2Name: String?
        var user2Image:String?
        if (Singleton.sharedInstance.user.id! > item?.object(forKey: "id") as! String){
            user1ID = item?.object(forKey: "id") as? String
            user1Image = item?.object(forKey: "person_image") as? String
            user1Name = item?.object(forKey: "name") as? String
            user2ID = Singleton.sharedInstance.user.id!
            user2Name = Singleton.sharedInstance.user.name!
            user2Image = Singleton.sharedInstance.user.userImageUrl!
        }
        else{
            user1ID =  Singleton.sharedInstance.user.id!
            user1Image = Singleton.sharedInstance.user.userImageUrl!
            user1Name =  Singleton.sharedInstance.user.name!
            user2ID = item?.object(forKey: "id") as? String
            user2Name =  item?.object(forKey: "name") as? String
            user2Image =  item?.object(forKey: "person_image") as? String
        }
        let value = ["chatId": makeKey(senderId: item?.object(forKey: "id") as! String),"user1ID":user1ID ?? "" , "user1Image":user1Image ?? "" , "user1Name":user1Name ?? "" , "user1Status": "","user2ID":  user2ID ?? "", "user2Image":user2Image ?? "" , "user2Name":  user2Name ?? "", "user2Status": "","lastMessage": lastMessage, "lastMessageFrom":item?.object(forKey: "id") as? String ?? "" , "lastMessageIsImage": false,"lastMessageTime": CommonUtility.getCurrentDate()] as [String : Any]
        return value
        
    }
    func makeKey(senderId: String) -> String{
        var retunString:String
        if (Singleton.sharedInstance.user.id! > senderId){
            retunString = senderId + "_" + Singleton.sharedInstance.user.id!
        }else{
            retunString = Singleton.sharedInstance.user.id! + "_" + senderId
        }
        return retunString
    }
}
//MARK:- UIGestureViewDelegates
extension NewRequestVC: UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: messageView))!{
            return false
        }
        return true
    }
}
