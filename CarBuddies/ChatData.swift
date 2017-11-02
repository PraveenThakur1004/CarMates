//
//  ChatData.swift
//  CarBuddies
//
//  Created by MAC on 29/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import  UIKit
import  Foundation
import  Firebase
class ChatData: NSObject {
//MARK: Properties
    var user1ID :String?
    var user1Image :String?
    var user1Name :String?
    var user1Status :String?
    var user2ID :String?
    var user2Image :String?
    var user2Name : String?
    var user2Status : String;
    var lastMessage : String?
    var lastMessageFrom :String?
    var lastMessageImage : String?
    var lastMessageTime :String?
    //MARK: Intialization
    init(user1ID:String,user1Image:String,user1Name:String,user1Status:String,user2ID:String,user2Image:String,user2Name:String,user2Status:String,lastMessage:String,lastMessageFrom:String,lastMessageIsImage:String,lastMessagetime:String) {
        self.user1ID = user1ID
        self.user1Image = user1Image
        self.user1Status = user1Status
        self.user1Name = user1Name
        self.user2ID = user2ID
        self.user2Image = user2Image
        self.user2Name = user2Name
        self.user2Status = user2Status
        self.lastMessageTime = lastMessagetime
        self.lastMessage = lastMessage
        self.lastMessageFrom = lastMessageFrom
        self.lastMessageImage = lastMessageIsImage
        }
      func chatDataasDictionary() -> [String: Any] {
        return["19_36": ["user1ID": user1ID! , "user1Image":user1Image! , "user1Name":user1Name! , "user1Status": user1Status!,"user2ID": user2ID!, "user2Image":user2Image! , "user2Name": user2Name!, "user2Status": user2Status,"lastMessage":lastMessage! , "lastMessageFrom":lastMessageFrom! , "lastMessageIsImage": lastMessageImage!, "lastMessageTime":lastMessageTime! ]];
    }
    //MARK: Methods
    class func checkForKey(_ toId:String,completion:@escaping (_ sucess:Bool) -> Swift.Void){
        Constants.firebasePath.base.child(Constants.firebasePath.child_Chat).child(toId).child(Constants.firebasePath.child_ChatData).observeSingleEvent(of: .value, with: { (snapshot) in
            var sucess:Bool?
            if snapshot.exists() {
                sucess = true
                completion(sucess!)
            }
            else{
                sucess = false
                completion(sucess!)
            }
        })
    }
    class func uploadData(withValues: [String: Any], toID: String, completion: @escaping (_ messageData:NSDictionary) -> Swift.Void){
        let dict =  ["\(toID)":["chatData": withValues]]
           Constants.firebasePath.base.child(Constants.firebasePath.child_Chat).updateChildValues(dict, withCompletionBlock: { (error, _) in
                    if error == nil {
                        completion(["lastMessage":"","lastMessagetime":"" ])
                    } else {
                        completion(["lastMessage":"","lastMessagetime":"" ])
                    }
                })
            }
    
    class func checkAndUpload(withValues: [String: Any], toID: String, completion: @escaping (_ messageData:NSDictionary) -> Swift.Void) {
    let dict =  ["\(toID)":["chatData": withValues]]
    Constants.firebasePath.base.child(Constants.firebasePath.child_Chat).child(toID).child(Constants.firebasePath.child_ChatData).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    let chatData = snapshot.value as? NSDictionary
                    print(chatData)
                    let lastMessage = chatData!.object(forKey: "lastMessage") as! String
                    let lastMessageTime = chatData!.object(forKey: "lastMessageTime") as! String
                    let lastMessageIsImage = chatData!.object(forKey: "lastMessageIsImage") as? Bool
                    let lastMessageFrom = chatData!.object(forKey: "lastMessageFrom") as! String
          completion(["lastMessage":lastMessage,"lastMessageTime":lastMessageTime,"lastMessageIsImage":lastMessageIsImage,"lastMessageFrom":lastMessageFrom] )
                    
                } else {
                    Constants.firebasePath.base.child(Constants.firebasePath.child_Chat).updateChildValues(dict, withCompletionBlock: { (error, _) in
                        if error == nil {
                            completion(["lastMessage":"","lastMessagetime":"" ])
                        } else {
                            completion(["lastMessage":"","lastMessagetime":"" ])
                        }
                    })
                }
            })
        
    }
    class func downloadAllChatData(forChatID: String, completion: @escaping ([ChatData]) -> Swift.Void) {
        // if let currentUserID = Auth.auth().currentUser?.uid {
   Constants.firebasePath.base.child(Constants.firebasePath.child_Chat).child("19_36").child(Constants.firebasePath.child_Chat).observe(.value, with: { (snapshot) in
            var value = [ChatData]()
    
            if snapshot.exists() {
                let data = snapshot.value as! [NSDictionary]
                print(data)
                value = getChatDataModel(data)
                completion(value)
            }
            else{
                completion(value)
            }
        })
        //}
    }
//  class func get
   class  fileprivate func getChatDataModel(_ array: [NSDictionary]) -> [ChatData] {
        var  items = [ChatData]()
        for item in array{
            let category =  ChatData(user1ID: item["user1ID"] as? String ?? "", user1Image: item["user1Image"] as? String ?? "", user1Name: item["user1Name"] as? String ?? "", user1Status: item["user1Status"] as? String ?? "",user2ID: item["user2ID"] as? String ?? "", user2Image: item["user2Image"] as? String ?? "", user2Name: item["user2Name"] as? String ?? "", user2Status: item["user2Status"] as? String ?? "",lastMessage: item["lastMessage"] as? String ?? "", lastMessageFrom: item["lastMessageFrom"] as? String ?? "", lastMessageIsImage: item["lastMessageImage"] as? String ?? "", lastMessagetime: item["lastMessageTime"] as? String ?? "")
            items += [category]
            
        }
        return items
    }
 
    
}
