//
//  ChatPTVC.swift
//  CarBuddies
//
//  Created by MAC on 28/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import Photos
import Firebase
import JSQMessagesViewController
import  FTIndicator

class ChatPTVC: JSQMessagesViewController {
    @IBOutlet weak var uploadingView:UIView!
    @IBOutlet weak var showprogess:UIProgressView!
    @IBOutlet weak var labelProgess:UILabel!
    @IBOutlet weak var uploadingBackgroundView: UIView!
    // MARK: Properties
    var firbaseKeyId: String?
    var otherUserImageUrl: String?
    var otherUserImge : UIImage?
    var otherUserID : String?
    var otherUserName : String?
    var picker:UIImagePickerController?=UIImagePickerController()
    var boolDeleteChat = false
    private let imageURLNotSetKey = "NOTSET"
    private var newMessageRefHandle: DatabaseHandle?
    private var updatedMessageRefHandle: DatabaseHandle?
    private var messages: [JSQMessage] = []
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    fileprivate lazy var storageRef: StorageReference = Storage.storage().reference()
    private var localTyping = false
    var wsManager: WebserviceManager!
//    var channel: Channel? {
//        didSet {
//            title = channel?.name
//        }
//    }
    
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
           // userIsTypingRef.setValue(newValue)
        }
    }
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
   // lazy var outgoingAvtarImageView: JSQMessagesAvatarImage = self.setupIncomingAvtar()
 //   lazy var incomingAvtarImageView: JSQMessagesAvatarImage = self.setupIncomingAvtar()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // FTIndicator.showProgress(withMessage: "loading")
     
        Message.downloadAllMessages(forFirebaseID: firbaseKeyId!, completion:{(message,sucess)-> Void in
            FTIndicator.dismissProgress()
            if sucess == true{
           let isImage = message.isImage
           if !isImage {
            
            self.addMessage(withId: message.fromID!, name: "", text: message.content as! String, time: message.time!)
                self.finishReceivingMessage()}
           else  {
                if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: message.fromID == self.senderId) {
                    var value:Date
                    if !(message.time?.isEmpty)!{
                        value = CommonUtility.getCurrentDate(message.time!)
                    }
                    else{
                        let currentDate = CommonUtility.getCurrentDate()
                        value = CommonUtility.getCurrentDate(currentDate)
                    }
                    self.addPhotoMessage(withId: message.fromID!, key:"",date: value, mediaItem: mediaItem)
                     self.finishReceivingMessage()
                    if (message.content as AnyObject).hasPrefix("gs://") {
                        self.fetchImageDataAtURL(message.content as! String, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: nil)
                    }
                }
            }
            
            }
        })
      
    }
    override func viewWillDisappear(_ animated: Bool) {
        if !boolDeleteChat{
        let userStatus:String
        if (Singleton.sharedInstance.user.id! > otherUserID!) {
            userStatus = "user2Status"
        }
        else{
            userStatus = "user1Status"
        }
        let status =   Database.database().reference().child("chat/\(firbaseKeyId!)/chatData/\(userStatus)")
       status.setValue("offline")
    }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = otherUserName
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Roboto-Medium", size: 14)!]
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
         self.setUpNavigationBar()
    }
 override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       }
   // MARK: Collection view data source (and related) methods
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
 override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        if message.senderId == senderId { // 1
            cell.textView?.textColor = UIColor.white // 2
        } else {
            cell.textView?.textColor = UIColor.black // 3
        }
        return cell
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            if let image = Singleton.sharedInstance.userImage
            {
              return JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 20)
                
            }
            else{
                return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named:"iconUser"), diameter: 20)}
        }
        else{
            if let image = otherUserImge
            {
                return JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 20)
                
            }
            else{
                return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named:"iconUser"), diameter: 20)
            }
        }
    }
   override  func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    override  func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
       let message = messages[indexPath.item]
    return NSAttributedString(string:CommonUtility.changeDateFormatZ(date: message.date))
        
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        if let selectedImage = self.getImage(indexPath: indexPath) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Slider", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "ID_ImagePreviewVC") as! ImagePreviewVC
            viewController.image = selectedImage
          self.present(viewController, animated: false, completion: nil)
        }
    }
    func getImage(indexPath: IndexPath) -> UIImage? {
        let message = self.messages[indexPath.row]
        if message.isMediaMessage == true {
            let mediaItem = message.media
            if mediaItem is JSQPhotoMediaItem {
                let photoItem = mediaItem as! JSQPhotoMediaItem
                if let test: UIImage = photoItem.image {
                    let image = test
                    return image
                }
            }
        }
        return nil
    }
// MARK: Firebase related methods
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        // 1
     
     //    JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        
        //2
        let message =   Message( content: text, time:CommonUtility.getCurrentDate(), isImage: false,fromID:Singleton.sharedInstance.user.id)
        Message.send(message: message, underId:firbaseKeyId!, toId: otherUserID! , completion: {(sucess) in
            if sucess{
            self.wsManager.fireNotification(self.otherUserID!, title: "NewMessage", message: text, completionHandler: { (_) in
                
            })
            
            }
            
        })
        // 4
        finishSendingMessage()
        // 5
       
        isTyping = false
    }
    // MARK: UI and User Interaction
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor(red: 188.0/255.0, green: 224.0/255.0, blue: 151/255.0, alpha: 1.0))
    }
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    override func didPressAccessoryButton(_ sender: UIButton) {
        self.showActionSheet()
    }
    
    private func addMessage(withId id: String, name: String, text: String,time:String) {
        var value:Date
        if !time.isEmpty{
        value = CommonUtility.getCurrentDate(time)
        }
        else{
            let currentDate = CommonUtility.getCurrentDate()
            value = CommonUtility.getCurrentDate(currentDate)
        }
        if let message = JSQMessage(senderId: id, senderDisplayName: name, date:value, text: text)
        {
            messages.append(message)
        }
    }

    private func addPhotoMessage(withId id: String, key: String, date: Date, mediaItem: JSQPhotoMediaItem) {
    if let message =   JSQMessage(senderId: id, senderDisplayName: "", date: date, media: mediaItem)
         {
            messages.append(message)
            
            if (mediaItem.image == nil) {
                photoMessageMap[key] = mediaItem
            }
            
            collectionView.reloadData()
        }
    }
    private func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
        let storageRef = Storage.storage().reference(forURL: photoURL)
      
        storageRef.getData(maxSize: INT64_MAX){ (data, error) in
            if let error = error {
                print("Error downloading image data: \(error)")
                return
            }
            
            storageRef.getMetadata(completion: { (metadata, metadataErr) in
                if let error = metadataErr {
                    print("Error downloading metadata: \(error)")
                    return
                }
                
                if (metadata?.contentType == "image/gif") {
                   // mediaItem.image = UIImage.
                } else {
                    mediaItem.image = UIImage.init(data: data!)
                }
                self.collectionView.reloadData()
                
                guard key != nil else {
                    return
                }
                self.photoMessageMap.removeValue(forKey: key!)
            })
        }
    }
    
    // MARK: UITextViewDelegate methods
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
    }
    

//func sendPhotoMessage() -> String? {
//    let itemRef = Constants.firebasePath.base.child(Constants.firebasePath.child_Chat).
//    
//    let messageItem = [
//        "photoURL": imageURLNotSetKey,
//        "senderId": senderId!,
//        ]
//    
//    itemRef.setValue(messageItem)
//    
//    JSQSystemSoundPlayer.jsq_playMessageSentSound()
//    
//    finishSendingMessage()
//    return itemRef.key
//}
    func setImageURL(_ url: String) {
      //2
        let message =   Message( content: url, time: CommonUtility.getCurrentDate(), isImage: true,fromID:Singleton.sharedInstance.user.id)
        Message.send(message: message, underId:firbaseKeyId!, toId: otherUserID! , completion: {(sucess) in
            if sucess{
            self.wsManager.fireNotification(self.otherUserID!, title: "NewMessage", message: "Image", completionHandler: { (_) in
                    
                })
            }
            
            
            
        })
        // 4
        finishSendingMessage()
        
}
}
// MARK: Image Picker Delegate
extension ChatPTVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                                                            didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
        var data = NSData()
        data = UIImageJPEGRepresentation(chosenImage, 0.8)! as NSData
            picker.dismiss(animated: true, completion:nil)
         let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                      self.uploadingBackgroundView.frame = (app.window?.bounds)!
                        app.window?.addSubview(self.uploadingBackgroundView)
                        app.window?.bringSubview(toFront: self.uploadingBackgroundView)
                        app.window?.makeKeyAndVisible()
            
                        // timeSetupView.fadeIn()
                        self.uploadingBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                        self.uploadingBackgroundView.isOpaque = true
        let filePath = "/\(Constants.firebasePath.child_StoreImages)/\(self.firbaseKeyId!)/\(Date.timeIntervalSinceReferenceDate)\("_" + self.senderId! + ".jpg")"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
      let uploadtask =  self.storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
                self.setImageURL(self.storageRef.child((metaData?.path)!).description)
                
               
            }
        // Observe changes in status
        uploadtask.observe(.progress) { snapshot in
            
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            self.showprogess.progress = Float(percentComplete)
            //                        let progressPercent = Int(percentComplete*100)
            //                        self.labelProgess.text = "\(progressPercent)%"
            
        }
        
        uploadtask.observe(.success) { snapshot in
            self.uploadingBackgroundView.removeFromSuperview()
        }
        
        }
    
}
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
}
