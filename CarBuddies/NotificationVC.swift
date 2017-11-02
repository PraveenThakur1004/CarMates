//
//  NotificationVC.swift
//  CarBuddies
//
//  Created by MAC on 21/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
class NotificationVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let wsManager = WebserviceManager()
    var items = [NSDictionary]()
    let kCellReuseIdentifier = "NotificationCell"
    override func viewDidLoad() {
        super.viewDidLoad()
       // tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 102
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Notification History"
      
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Roboto-Medium", size: 14)!]
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.SetBackBarButtonCustom()
        items = [NSDictionary]()
        self.tableView.reloadData()
        self.getData()
    }
    //MARK- Navigation Back Button
    func SetBackBarButtonCustom()
    {
        //Back buttion
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "back"), for: UIControlState())
        btnLeftMenu.addTarget(self, action: #selector(self.onClcikBack), for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    //Navigation back button action
    func onClcikBack()
    {
        _ = self.navigationController?.popViewController(animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getData(){
        FTIndicator.showProgress(withMessage: "loading..")
        wsManager.allNotificationList(completionHandler:{(items,sucess,message)-> Void in
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
    //MARK:- Download Images
    
}
/*
 Extention of `NavigationMenuViewController` class, implements table view delegates methods.
 */
extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath) as! NotificationCell
        cell.layer.backgroundColor = UIColor.clear.cgColor
        let item = items[(indexPath as NSIndexPath).row]
        let notificationData = item.object(forKey: "notification") as! NSDictionary
       cell.userNameLabel.text = notificationData.object(forKey: "title") as? String
        cell.feedbackLabel.text = notificationData.object(forKey: "message") as? String
        cell.timeLabel.text  = CommonUtility.dateformatter(str: (notificationData.object(forKey: "created") as? String)!)
//        cell.thumbnailImageView.image = nil
//        cell.activityIndicator.isHidden = false
//        cell.activityIndicator.startAnimating()
        if tableView.isDragging == false && tableView.isDecelerating == false {
          //  downloadImageForItem(item, indexPath: indexPath)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[(indexPath as NSIndexPath).row]
         let notificationData = item.object(forKey: "notification") as! NSDictionary
        if let value = notificationData.object(forKey: "title") as? String {
         if value == "Request Re-received"||value == "Request Accepted"{
            let data  = item.object(forKey: "user") as! NSDictionary
            self.checkFirebaseData(data)
        }
        }
        //        guard let menuContainerViewController = self.menuContainerViewController else {
        //            return
        //        }
        //
        //        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
        //        menuContainerViewController.hideSideMenu()
    }
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        // action two
//        let rejectAction = UITableViewRowAction(style: .default, title: "DELETE", handler: { (action, indexPath) in
//            //            let item = self.items[(indexPath as NSIndexPath).row]
//            //            let user = item.object(forKey: "Request") as! NSDictionary
//            // self.rejectRequest(requestID: user.object(forKey: "id") as? String, index: indexPath)
//        })
//        // deleteAction.backgroundColor = UIColor(patternImage: UIImage(named: "cancel")!)
//        rejectAction.backgroundColor = UIColor.red
//        return [ rejectAction]
//    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            // handle delete (by removing the data from your array and updating the tableview)
//        }
//    }
    
}
