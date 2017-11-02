//
//  HomeVC.swift
//  CarBuddies
//
//  Created by MAC on 20/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
//import PageMenu
import CarbonKit
import FTIndicator
import Firebase
import UserNotifications
class HomeVC: UIViewController,UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var scrollerView: UIView!
    @IBOutlet weak var userProfileBtn: UIButton!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    @IBOutlet weak var lbl_Badge:UILabel!
    //var pageMenu : CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    var searchText : String?
    var notificationBadge = 0
    fileprivate var wsManager: WebserviceManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        wsManager =  WebserviceManager()
       
        if notificationBadge > 0{
            lbl_Badge.isHidden = false
        }else{
            lbl_Badge.isHidden = true
        }
        
        UNUserNotificationCenter.current().delegate = self
 if let devicetoken = Singleton.sharedInstance.deviceToken{        if devicetoken != ""{
        wsManager.updateToken(devicetoken, completionHandler: {(sucess)-> Void in
            if sucess{
                }
        })}}
        let items = ["Ongoing Chat", "New Messages","Sent Messages"]
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(self.view.frame.size.width/3, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(self.view.frame.size.width/3, forSegmentAt: 1)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(self.view.frame.size.width/3, forSegmentAt: 2)
        
        
        carbonTabSwipeNavigation.setIndicatorColor(UIColor.white)
        
        carbonTabSwipeNavigation.setTabExtraWidth(30)
        
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.white.withAlphaComponent(0.6))
        carbonTabSwipeNavigation.setSelectedColor(UIColor.white, font: UIFont.boldSystemFont(ofSize: 14))
        carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: scrollerView)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        wsManager = WebserviceManager()
        guard let imageUrlString = Singleton.sharedInstance.user.userImageUrl else {
            return
        }
                // self.activityIndicator.startAnimating()
                wsManager.downloadImage2(URL(string: imageUrlString), completionHandler: { (image) -> Void in
                    DispatchQueue.main.async(execute: { () -> Void in
                        // self.activityIndicator.stopAnimating()
                      Singleton.sharedInstance.userImage = nil
                        self.userProfileBtn.setBackgroundImage(image, for: UIControlState.normal)
                        Singleton.sharedInstance.userImage = image
        
                    })
                })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func action_Notification(_ sender: Any) {
        lbl_Badge.text = ""
        lbl_Badge.isHidden = true
        notificationBadge = 0
        self.performSegue(withIdentifier: "segueNotification", sender: self)
        //  showSearchBar()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
        let content = notification.request.content
        let badgeNumber = content.badge as! Int
        print("badge:\(badgeNumber)")
        notificationBadge = notificationBadge + 1
        print("badge:\(notificationBadge)")
        lbl_Badge.isHidden = false
        lbl_Badge.text = String(notificationBadge)
        
    }
    
}
extension HomeVC:CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        // return viewController at index
        let storyboard = UIStoryboard(name: "Slider", bundle: nil)
        switch (index) {
        case 0:
            return storyboard.instantiateViewController(withIdentifier :"ID_OngoingVC") as! OngoingVC
            
        case 1:
            return storyboard.instantiateViewController(withIdentifier :"ID_NewRequestVC") as! NewRequestVC
        case 2:
            return storyboard.instantiateViewController(withIdentifier :"ID_SentRequestVC") as! SentRequestVC
        default:
            return storyboard.instantiateViewController(withIdentifier :"ID_OngoingVC") as! OngoingVC
        }
    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        NSLog("Did move at index: %ld", index)
    }
    
    
}


