//
//  SearchResultVC.swift
//  CarBuddies
//
//  Created by MAC on 21/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
class SearchResultVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let kCellReuseIdentifier = "SearchResultCell"
    let wsManager = WebserviceManager()
    var searchText:String?
    var selectedUserId:String?
    var selcetedUserLicence:String?
    var selectedCategoryArray:NSArray?
    var items = [NSDictionary]()
    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRect(x:10,y:15,width:280,height:40))
    override func viewDidLoad() {
        super.viewDidLoad()
       // Do any additional setup after loadivarthe view.
        searchBar.placeholder = "Search License Plates"
        searchBar.delegate = self
        searchBar.searchBarStyle = .prominent
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.rightBarButtonItem = leftNavBarButton
        }
    func getResult(){
        FTIndicator.showProgress(withMessage:"loading")
        wsManager.searchLicenceNumber(searchText!, completionHandler:{(items,sucess, message)-> Void in
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
            
    })    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       // self.navigationItem.title = "Search Result"
     
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Roboto-Medium", size: 14)!]
          self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.SetBackBarButtonCustom()
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
    //MARK:- Download Images
    func downloadImageForItem(_ item: NSDictionary, indexPath: IndexPath) {
        let str: String = item.object(forKey: "person_image") as! String
        print(str)
        wsManager.downloadImage2(URL(string: str), completionHandler: { (image) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if let cell = self.tableView.cellForRow(at: indexPath) as?SearchResultCell {
                    cell.thumbnailImageView.image = image
                }
            })
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueNofifyCategory" {
            let vc = segue.destination as! SelectCategoryVC
            vc.items =  self.getCategory(selectedCategoryArray as! [NSDictionary])
            vc.otherUserId = selectedUserId
            vc.otherUserlicNum = selcetedUserLicence
        }
    }
    //GetCategory
    fileprivate func getCategory(_ array: [NSDictionary]) -> [CategoryModel] {
        var items = [CategoryModel]()
        print("array valuse\(array)")
        for item in array{
            let category =  CategoryModel(categoryName: item["name"] as? String ?? "", categoryImageUrl: item["category_image"] as? String ?? "", categoryId: item["id"] as? String ?? "", categoryDesc: item["cat_des"] as? String ?? "")
            items += [category]
            
        }
        return items
    }
}

/*
 Extention of `NavigationMenuViewController` class, implements table view delegates methods.
 */
extension SearchResultVC:UISearchBarDelegate{
    //MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text
        guard searchText != nil else {
            FTIndicator.showProgress(withMessage: "Enter licence number")
            return
        }
        searchBar.text = ""
        searchBar.resignFirstResponder()
        items = [NSDictionary]()
        self.tableView.reloadData()
        self.getResult()
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    
}
extension SearchResultVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath) as! SearchResultCell
        cell.layer.backgroundColor = UIColor.clear.cgColor
        let item = items[(indexPath as NSIndexPath).row]
        let user = item.object(forKey: "User") as! NSDictionary
        print(user)
        cell.licencePlateNumber.text =  user.object(forKey: "licence_no") as? String
       // cell.thumbnailImageView.image = nil
        if tableView.isDragging == false && tableView.isDecelerating == false {
           // downloadImageForItem(user, indexPath: indexPath)
        }
 
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[(indexPath as NSIndexPath).row]
        let user = item.object(forKey: "User") as! NSDictionary
        print(user)
        selectedCategoryArray =  user.object(forKey: "cat")
            as? NSArray
        selectedUserId = user.object(forKey: "id") as? String
        selcetedUserLicence = user.object(forKey: "licence_no") as? String
        guard (selectedCategoryArray != nil) else {
            return
        }
      
        self.performSegue(withIdentifier: "segueNofifyCategory", sender: self)
       
    }
}

