//
//  Notification+Extension.swift
//  CarBuddies
//
//  Created by MAC on 03/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import Foundation
import UIKit
import  FTIndicator
extension NotificationVC{
    func checkFirebaseData(_ item: NSDictionary){
        print(item)
        ChatData.checkForKey(makeKey(senderId: item.object(forKey: "id") as! String), completion: {(sucess) -> Void in
            if sucess{
               let storyBoard: UIStoryboard = UIStoryboard(name: "Slider", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ID_ChatPTVC") as! ChatPTVC
                vc.senderId = Singleton.sharedInstance.user.id
                vc.senderDisplayName = Singleton.sharedInstance.user.name
                vc.otherUserID = item.object(forKey: "id") as? String
                vc.otherUserName = item.object(forKey: "name") as? String
                vc.firbaseKeyId = self.makeKey(senderId: item.object(forKey: "id") as! String)
                vc.otherUserImageUrl = item.object(forKey: "person_image") as? String
                self.navigationController?.pushViewController(vc, animated: true)
            
            }
            else{
            FTIndicator.showToastMessage("No chat found")
            
            }
        })
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
