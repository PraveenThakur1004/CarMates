//
//  SendNotificationVC.swift
//  CarBuddies
//
//  Created by MAC on 09/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import  FTIndicator

class SendNotificationVC: UIViewController {
    
    
    @IBOutlet weak var textView_SendMessage: UITextView!
    var otherUserID:String?
    var selectedCategory:String?
    fileprivate var wsManager: WebserviceManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        wsManager =  WebserviceManager()
        self.title = "Send Notification"
         self.navigationItem.title = "Send Notification"
     textView_SendMessage.placeholder = "Type your message here"
        self.SetBackBarButtonCustom()
        // Do any additional setup after loading the view.
    }
    func SetBackBarButtonCustom()
    {
        //Back button
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "back"), for: UIControlState())
        btnLeftMenu.addTarget(self, action: #selector(self.onClcikBack), for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let barButtonleft = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButtonleft
        
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
@IBAction func action_SendNotification(_ sender: Any) {
    if (textView_SendMessage.text == ""){
    FTIndicator.showToastMessage("Please enter the message first")
    }
    FTIndicator.showProgress(withMessage: "Sending")
    wsManager.sendRequest(otherUserID!, message: textView_SendMessage.text, forCategories: selectedCategory!, completionHandler: {(sucess, message)-> Void in
            if sucess{
                FTIndicator.dismissProgress()
                FTIndicator.showToastMessage(message)
                for vc in self.navigationController!.viewControllers {
                    // Check if the view controller is of MyGroupViewController type
                    if let myHomeVC = vc as? HomeVC {
                        self.navigationController?.popToViewController(myHomeVC, animated: true)
                    }
                }
            }
            else{
                FTIndicator.dismissProgress()
                FTIndicator.showToastMessage(message)
            }
        })
    }
    
    }

