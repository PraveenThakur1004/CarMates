//
//  AppDelegate.swift
//  CarBuddies
//
//  Created by MAC on 20/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
import IQKeyboardManagerSwift
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    var window: UIWindow?
    let wsManager = WebserviceManager()
    
    func  application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().delegate = self
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 132/255, green: 215/255, blue: 150/255, alpha: 1)
     //   UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        Singleton.sharedInstance.deviceToken = ""
        FTIndicator.setIndicatorStyle(.dark)
        IQKeyboardManager.sharedManager().enable = true
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
        //MARK- Auto login
        if (UserDefaults.standard.object(forKey: "user_email") as? String) != nil{
            let dict = UserDefaults.standard.object(forKey: "user")
            Singleton.sharedInstance.user = getUser(dict as! [String : AnyObject])
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Slider", bundle: nil)
            let exampleViewController: HomeVC = mainStoryboard.instantiateViewController(withIdentifier: "ID_HomeVC") as! HomeVC
            let navigationController = UINavigationController(rootViewController: exampleViewController);
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        //MARK - Get Categories
        wsManager.getCategory(completionHandler: {(category,sucess, message)-> Void in
            if sucess{
                Singleton.sharedInstance.categoryArray = category
                
            }
        })
        
        
        return true
    }
    //SetUp user model
    fileprivate func getUser(_ dict: [String: AnyObject]) -> User {
        let user = User(id: dict["id"] as? String ?? "", userImageUrl: dict["person_image"] as? String ?? "",name: dict["name"] as? String ?? "", email: dict["email"] as? String ?? "", licenceNumber: dict["licence_no"] as? String ?? "", category: dict["category"] as? String ?? "", password: dict["password"] as? String ?? "")
        return user
    }
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        Singleton.sharedInstance.deviceToken = deviceTokenString
        }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
          let content = notification.request.content
          let badgeNumber = content.badge as! Int
        print("badge:\(badgeNumber)")
        
    }
    
    }

