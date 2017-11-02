//
//  OngoingChatFirebse+extension.swift
//  CarBuddies
//
//  Created by MAC on 29/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import Foundation
import UIKit
extension OngoingVC{
    func checkFirebaseData(_ item: NSDictionary, indexPath: IndexPath){
    let value = self.setChatData(item)
        ChatData.checkAndUpload(withValues: value ,toID: makeKey(senderId: item.object(forKey: "id") as! String), completion: {(message) -> Void in
        DispatchQueue.main.async(execute: { () -> Void in
            if let cell = self.tableView.cellForRow(at: indexPath) as?MessageCell {
                if let check = message.object(forKey: "lastMessageIsImage") as? Bool{
                    if check {
                        cell.feedbackLabel.text = "image"
                    }
                    else{
                        if let lastmessage = message.object(forKey: "lastMessage") as? String{
                            cell.feedbackLabel.text = lastmessage 
                        }
                        else{
                            cell.feedbackLabel.text = "Send your first message.."
                        }
                    }
                }
                
                
                if let time = message.object(forKey: "lastMessageTime") as? String{
                    if time != ""{
                        cell.timeLabel.text = CommonUtility.dateformatterZ(str: time)
                    }
                }else{

                }
               
            }
        })
    })
    }
    fileprivate func setChatData(_ item: NSDictionary) -> [String:Any]  {
        print("the item is \(item)")
        var user1ID :String?
        var user1Image:String?
        var user1Name:String?
        var user2ID : String?
        var user2Name: String?
        var user2Image:String?
        if (Singleton.sharedInstance.user.id! > item.object(forKey: "id") as! String){
             user1ID = item.object(forKey: "id") as? String
             user1Image = item.object(forKey: "person_image") as? String
             user1Name = item.object(forKey: "name") as? String
             user2ID = Singleton.sharedInstance.user.id!
             user2Name = Singleton.sharedInstance.user.name!
             user2Image = Singleton.sharedInstance.user.userImageUrl!
        }
        else{
            user1ID =  Singleton.sharedInstance.user.id!
            user1Image = Singleton.sharedInstance.user.userImageUrl!
            user1Name =  Singleton.sharedInstance.user.name!
            user2ID = item.object(forKey: "id") as? String
            user2Name =  item.object(forKey: "name") as? String
            user2Image =  item.object(forKey: "person_image") as? String
        }
       let value = ["chatId": makeKey(senderId: item.object(forKey: "id") as! String),"user1ID":user1ID ?? "" , "user1Image":user1Image ?? "" , "user1Name":user1Name ?? "" , "user1Status": "","user2ID":  user2ID ?? "", "user2Image":user2Image ?? "" , "user2Name":  user2Name ?? "", "user2Status": "","lastMessage":"Send your first message.." , "lastMessageFrom":Singleton.sharedInstance.user.id ?? "" , "lastMessageIsImage": false,"lastMessageTime": CommonUtility.getCurrentDate()] as [String : Any]
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
