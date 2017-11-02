//
//  SentRequestVC.swift
//  CarBuddies
//
//  Created by MAC on 20/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
class SentRequestVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let kCellReuseIdentifier = "SendRequstsCell"
    let wsManager = WebserviceManager()
    var items = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 102
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
         items = [NSDictionary]()
         self.tableView.reloadData()
         self.getData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getData(){
     FTIndicator.showProgress(withMessage: "loading..")
     wsManager.allSentRequests(completionHandler:{(items,sucess,message)-> Void in
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
    }
    @IBAction func actionDismissPresent(_ sender: UIButton) {
        
dismiss(animated: true, completion: nil)
        
    }
    //MARK:- Download Images
    func downloadImageForItem(_ item: NSDictionary, indexPath: IndexPath) {
        let str: String = (item.object(forKey: "person_image") as? String)!
        print(str)
        wsManager.downloadImage2(URL(string: str), completionHandler: { (image) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if let cell = self.tableView.cellForRow(at: indexPath) as?RequestCell {
                 // let blurrImage = CommonUtility.blurImage(image: image!)
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
extension SentRequestVC: UITableViewDelegate, UITableViewDataSource {
    
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
        let request = item.object(forKey: "Request") as! NSDictionary
        print(user)
        cell.licenceNumberlbl.text =  user.object(forKey: "licence_no") as? String
        cell.timeLabel.text = CommonUtility.dateformatter(str: request.object(forKey: "created") as! String)
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
}

