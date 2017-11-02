//
//  OngoingVC.swift
//  CarBuddies
//
//  Created by MAC on 20/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
import  Firebase
class OngoingVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let wsManager = WebserviceManager()
    var selectedImage: UIImage?
    var items = [NSDictionary]()
    var selectedUser = NSDictionary()
    let kCellReuseIdentifier = "MessageCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 102
        
    }
        override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        FTIndicator.dismissProgress()
        items = [NSDictionary]()
        self.tableView.reloadData()
        self.getData()
    }
    func getData(){
        FTIndicator.showProgress(withMessage: "loading..")
        wsManager.allrecentChatList(completionHandler:{(items,sucess,message)-> Void in
            if sucess{
                FTIndicator.dismissProgress()
                if (items?.isEmpty)!{
                    FTIndicator.showToastMessage("No data found")
                }
                else{
                    self.items = items!
                    self.tableView.reloadData()
                }
            }
            else{
                FTIndicator.dismissProgress()
                FTIndicator.showToastMessage(message)
            }
        })
        FTIndicator.dismissProgress()
    }
        @IBAction func actionDismissPresent(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    //MARK:- Download Images
    func downloadImageForItem(_ item: NSDictionary, indexPath: IndexPath) {
        let str: String = item.object(forKey: "person_image") as! String
        print("here is imageUrl\(str)")
        //TODO:-
        wsManager.downloadImage2(URL(string: str), completionHandler: { (image) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if let cell = self.tableView.cellForRow(at: indexPath) as?MessageCell {
                    cell.thumbnailImageView.image =
                        image?.resizeImageWith(newSize: CGSize(width: 55, height: 55))
                    cell.activityIndicator.stopAnimating()
                    cell.activityIndicator.isHidden = true
                }
            })
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueChat" {
            let vc = segue.destination as! ChatPTVC
            vc.senderId = Singleton.sharedInstance.user.id
            vc.senderDisplayName = Singleton.sharedInstance.user.name
            vc.otherUserID = selectedUser.object(forKey: "id") as? String
            vc.otherUserName = selectedUser.object(forKey: "name") as? String
            vc.firbaseKeyId = makeKey(senderId: (selectedUser.object(forKey: "id") as? String)!)
            vc.otherUserImageUrl = selectedUser.object(forKey: "person_image") as? String
            let userStatus:String
            if (Singleton.sharedInstance.user.id! > (selectedUser.object(forKey: "id") as? String)!){
                userStatus = "user2Status"
            }
            else{
                userStatus = "user1Status"
            }
         let status =   Database.database().reference().child("chat/\(makeKey(senderId: (selectedUser.object(forKey: "id") as? String)!))/chatData/\(userStatus)")
           status.setValue("online")
            }
    }
    
}

/*
 Extention of `NavigationMenuViewController` class, implements table view delegates methods.
 */
extension OngoingVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath) as! MessageCell
        cell.layer.backgroundColor = UIColor.clear.cgColor
        let item = items[(indexPath as NSIndexPath).row]
        cell.userNameLabel.text = item.object(forKey: "name") as? String
        cell.thumbnailImageView.image = nil
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        if tableView.isDragging == false && tableView.isDecelerating == false {
            checkFirebaseData(item, indexPath: indexPath)
            downloadImageForItem(item, indexPath: indexPath)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = (items[(indexPath as IndexPath).row])
        self.performSegue(withIdentifier: "segueChat", sender: self)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //
    //        // action one
    //        let acceptAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
    //
    //
    //        })
    //        acceptAction.backgroundColor = UIColor(patternImage: UIImage(named: "accept")!)
    //        // action two
    //        let rejectAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
    //
    //        })
    //        rejectAction.backgroundColor = UIColor(patternImage: UIImage(named: "reject")!)
    //
    //        return [acceptAction, rejectAction]
    //    }
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        if (editingStyle == UITableViewCellEditingStyle.delete) {
    //            // handle delete (by removing the data from your array and updating the tableview)
    //        }
    //    }
    
}

