//  MIT License

//  Copyright (c) 2017 Haik Aslanyan

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import Foundation
import UIKit
import Firebase
import FTIndicator
class Message {
    //MARK: Properties
  
    var content: Any
    var time: String?
    var isImage: Bool
    var image: UIImage?
    var fromID: String?
    private var firebaseID: String?
    let wsManager = WebserviceManager()
    
    //MARK: Methods
  class  func deleteChatFunction(childIWantToRemove: String, completion: @escaping (Bool) -> Swift.Void)  {
        Database.database().reference().child(Constants.firebasePath.child_Chat).child(childIWantToRemove).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
                completion(false)
            }
            else{
                completion(true)
            }
        }
    }
    class func downloadAllMessages(forFirebaseID: String, completion: @escaping (_ message:Message, _ sucess: Bool) -> Swift.Void) {
         Database.database().reference().child(Constants.firebasePath.child_Chat).child(forFirebaseID).child(Constants.firebasePath.child_Messages).observe(.childAdded, with: { (snapshot) in
            var message:Message?
            var sucess:Bool?
                if snapshot.exists() {
                    sucess = true
                  let receivedMessage = snapshot.value as! [String: Any]
//                            let messageType = receivedMessage["image"] as! Bool
//                     var type = MessageType.text
//                    if MessageType{
//                    }
//                    
//                          var type = MessageType.text
//                            switch messageType {
//                                case "photo":
//                                type = .photo
//                                
//                            default: break
                    
//                            }
                    print(receivedMessage)
                            
                            let content = receivedMessage["message"] as! String
                            let fromID = receivedMessage["messageFromUser"] as! String
                            let timestamp = receivedMessage["time"] as! String
                           let isImage = receivedMessage["image"] as? Bool
                    let lastMessage = Database.database().reference().child(byAppendingPath: "chat/\(forFirebaseID)/chatData/lastMessage")
                    let lastMessageFrom = Database.database().reference().child(byAppendingPath: "chat/\(forFirebaseID)/chatData/lastMessageFrom")
                    let lastMessageIsImage = Database.database().reference().child(byAppendingPath: "chat/\(forFirebaseID)/chatData/lastMessageIsImage")
                    let lastMessageTime = Database.database().reference().child(byAppendingPath: "chat/\(forFirebaseID)/chatData/lastMessageTime")
                    lastMessage.setValue(content)
                    lastMessageFrom.setValue(fromID)
                    lastMessageIsImage.setValue(isImage)
                    lastMessageTime.setValue(timestamp)
//                      Database.database().reference().child(Constants.firebasePath.child_Chat).child(forFirebaseID).child(Constants.firebasePath.child_Chat).updateChildValues(["lastMessage":content])
                    
                    
                                message = Message.init( content: content, time: timestamp, isImage: isImage!, fromID: fromID)
                                completion(message!,sucess!)
                                                    }
                
                else{
                    sucess = false
                    message = Message.init( content: "", time: "", isImage: false, fromID: "")
                    completion(message!,sucess!)
                }
            })
     
    }
    class  func statusHandler(_ str:String,forFirebaseID:String){
      //  str = "user1ID"
    Database.database().reference().child(Constants.firebasePath.child_Chat).child(forFirebaseID).child(Constants.firebasePath.child_ChatData).observe(DataEventType.childChanged, with: { (snapshot) in
       guard let value = snapshot.value as? String else { return }
        guard let key = snapshot.key as? String else { return }
      guard let userBalance = value as? String else { return }
    
    print (userBalance)
    print(key)
        if str == key || value == "offline"{
        
        
        }
    
    })
    
    
    }
    func downloadImage(indexpathRow: Int, completion: @escaping (Bool, Int) -> Swift.Void)  {
        if self.isImage == true {
            let imageLink = self.content as! String
            let imageURL = URL.init(string: imageLink)
            URLSession.shared.dataTask(with: imageURL!, completionHandler: { (data, response, error) in
                if error == nil {
                    self.image = UIImage.init(data: data!)
                    completion(true, indexpathRow)
                }
            }).resume()
        }
    }
    
    class func send(message: Message, underId: String,toId:String, completion: @escaping (Bool) -> Swift.Void)  {
       
            
                let values = ["image": message.isImage, "message": message.content, "messageFromUser": message.fromID ?? "", "time": message.time ?? ""]
                Message.uploadMessage(withValues: values, underId: underId, completion: { (status) in
                    if status{
                        let userStatus:String
                        if (Singleton.sharedInstance.user.id! > toId) {
                            userStatus = "user1Status"
                        }
                        else{
                            userStatus = "user2Status"
                        }
         Constants.firebasePath.base.child(Constants.firebasePath.child_Chat).child(underId).child(Constants.firebasePath.child_ChatData).child(userStatus).observeSingleEvent(of: .value, with: { (snapshot) in
                 var sucess = false
                        if snapshot.exists() {
                            let newValue = snapshot.value as? String
                            print(newValue)
                            if newValue == "offline" {
                                sucess = true
                            completion(sucess)
                            
                            
                            }
                        }
                        
                    })
                    completion(status)
                    }
                })
            }
    
    class func uploadMessage(withValues: [String: Any], underId: String, completion: @escaping (_ status:Bool) -> Swift.Void) {
       
        Constants.firebasePath.base.child(Constants.firebasePath.child_Chat).child(underId).child(Constants.firebasePath.child_Messages).childByAutoId().updateChildValues(withValues, withCompletionBlock: { (error, _) in
                    var sucess = false
                    if error == nil {
                        sucess = true
                        completion(sucess)
                    } else {
                        completion(sucess)
                    }
                })
            }
    
        
    
    
//
//
//    class func uploadMessage(withValues: [String: Any], toID: String, completion: @escaping (Bool) -> Swift.Void) {
//        if let currentUserID = Auth.auth().currentUser?.uid {
//            Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).observeSingleEvent(of: .value, with: { (snapshot) in
//                if snapshot.exists() {
//                    let data = snapshot.value as! [String: String]
//                    let location = data["location"]!
//                    Database.database().reference().child("conversations").child(location).childByAutoId().setValue(withValues, withCompletionBlock: { (error, _) in
//                        if error == nil {
//                            completion(true)
//                        } else {
//                            completion(false)
//                        }
//                    })
//                } else {
//                    Database.database().reference().child("conversations").childByAutoId().childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in
//                        let data = ["location": reference.parent!.key]
//                        Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).updateChildValues(data)
//                        Database.database().reference().child("users").child(toID).child("conversations").child(currentUserID).updateChildValues(data)
//                        completion(true)
//                    })
//                }
//            })
//        }
//    }
    
    //MARK: Inits
    init(content: Any, time: String, isImage: Bool , fromID: String?) {
     
        self.content = content
        self.time = time
        self.isImage = isImage
        self.fromID = fromID
    }
}
