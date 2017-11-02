//
//  NewRequestVC.swift
//  CarBuddies
//
//  Created by MAC on 20/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator

class NewRequestVC: UIViewController {
    @IBOutlet weak var popUpDetailView:UIView!
    @IBOutlet weak var messageView:UIView!
    @IBOutlet weak var tableView: UITableView!
    let wsManager = WebserviceManager()
    var items = [NSDictionary]()
    let kCellReuseIdentifier = "RequestCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 102
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
         items = [NSDictionary]()
        self.tableView.setEditing(false, animated: true)
         self.tableView.reloadData()
         self.getData()
            // Do your stuff here
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getData(){
        FTIndicator.showProgress(withMessage: "loading..")
        wsManager.allReceivedRequests(completionHandler:{(items,sucess,message)-> Void in
            if sucess{
                FTIndicator.dismissProgress()
                if (items?.isEmpty)!{
                    FTIndicator.showToastMessage("No data found")
                }
                else{
                    if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
                        } else {
                   UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
                        UserDefaults.standard.synchronize()
                        self.setUpDetailView()
                    }
                    self.items = items!
                    self.tableView.reloadData()
                }
            }
            else{
                FTIndicator.dismissProgress()
                 FTIndicator.showToastMessage(message)
            }
        })
    }
    func acceptRequest(requestDict:NSDictionary?, index:IndexPath){
        
        let user = requestDict?.object(forKey: "Request") as! NSDictionary
        let requestId = user.object(forKey: "id") as? String
        FTIndicator.showProgress(withMessage: "loading..")
        wsManager.acceptRequest(requestId!, completionHandler:{(sucess,message)-> Void in
            if sucess{
                self.checkFirebaseData(requestDict!)
                //FTIndicator.dismissProgress()
               // self.items.remove(at: index.row)
               // FTIndicator.showToastMessage("Request accepted")
               // self.tableView.reloadData()
                
                
                }
            else{
                FTIndicator.dismissProgress()
                FTIndicator.showToastMessage(message)
            }
        })
    }
    func rejectRequest(requestID:String?, index:IndexPath){
        FTIndicator.showProgress(withMessage: "loading..")
        wsManager.rejectRequest(requestID!, completionHandler:{(sucess,message)-> Void in
            if sucess{
                FTIndicator.dismissProgress()
                self.items.remove(at: index.row)
                FTIndicator.showToastMessage("Request rejected")
                self.tableView.reloadData()
            }
            else{
                FTIndicator.dismissProgress()
                FTIndicator.showToastMessage(message)
            }
        })
    }
    @IBAction func actionDismissPresent(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func actionHideView(_ sender: Any) {
        self.popUpDetailView.removeFromSuperview()
    }
    @IBAction func hideDetailView(_ sender: Any) {
        self.popUpDetailView.removeFromSuperview()
        self.tableView.setEditing(true, animated: true)
    }

    //MARK:- Download Images
    func downloadImageForItem(_ item: NSDictionary, indexPath: IndexPath) {
        let str: String = item.object(forKey: "person_image") as! String
        print(str)
        //TODO:-
        wsManager.downloadImage2(URL(string: str), completionHandler: { (image) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if let cell = self.tableView.cellForRow(at: indexPath) as?RequestCell {
                   //let blurrImage = CommonUtility.blurImage(image: image!)
                    cell.thumbnailImageView.image = image?.resizeImageWith(newSize: CGSize(width: 55, height: 55))
                    cell.activityIndicator.stopAnimating()
                    cell.activityIndicator.isHidden = true
                }
            })
        })
    }
}

/*
 Extention of `NavigationMenuViewController` class, implements table view delegates methods.
 */
extension NewRequestVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath) as! RequestCell
        cell.layer.backgroundColor = UIColor.clear.cgColor
        let item = items[(indexPath as NSIndexPath).row]
        let user = item.object(forKey: "User") as! NSDictionary
        print(user)
        let request = item.object(forKey: "Request") as! NSDictionary
        cell.timeLabel.text = CommonUtility.dateformatter(str: request.object(forKey: "created") as! String)
        cell.licenceNumberlbl.text =  user.object(forKey: "licence_no") as? String
        cell.userNameLabel.text = user.object(forKey: "name") as? String
        cell.thumbnailImageView.image = nil
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        if tableView.isDragging == false && tableView.isDecelerating == false {
            downloadImageForItem(user, indexPath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        //        guard let menuContainerViewController = self.menuContainerViewController else {
        //            return
        //        }
        //
        //        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
        //        menuContainerViewController.hideSideMenu()
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action one
        let acceptAction = UITableViewRowAction(style: .default, title:  "        ", handler: { (action, indexPath) in
           
            let item = self.items[(indexPath as NSIndexPath).row]
            
            self.acceptRequest(requestDict: item, index: indexPath)
        })
       
        acceptAction.backgroundColor = UIColor(patternImage: UIImage(named: "accept")!)
        // action two
        let rejectAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
            let item = self.items[(indexPath as NSIndexPath).row]
            let user = item.object(forKey: "Request") as! NSDictionary
            self.rejectRequest(requestID: user.object(forKey: "id") as? String, index: indexPath)
        })
         rejectAction.backgroundColor = UIColor(patternImage: UIImage(named: "reject")!)
        
        return [acceptAction, rejectAction]
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (indexPath.row == 0)
        {
            return UITableViewCellEditingStyle.delete
        }
        else
        {
            return UITableViewCellEditingStyle.none
        }
    }
    
       
    }


