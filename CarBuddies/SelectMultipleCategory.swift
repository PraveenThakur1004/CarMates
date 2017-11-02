//
//  SelectMultipleCategory.swift
//  CarBuddies
//
//  Created by MAC on 23/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import  FTIndicator
protocol SelectedMultipleCartegoryDelegate {
    func  selectedCatagoryArray(array:NSArray)
}
class SelectMultipleCategory: UIViewController {
    
    @IBOutlet var popUpDetailView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var detail_Lbl: UILabel!
    @IBOutlet weak var  headinglbl: UILabel!
    @IBOutlet weak var  bottomBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate let reuseIdentifier = "CategoryCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
    fileprivate let itemsPerRow: CGFloat = 2
    var items = [CategoryModel]()
    var delegate: SelectedMultipleCartegoryDelegate?
    var selectedCategoryArray = [String]()
    var fromView:String?
    fileprivate var wsManager: WebserviceManager!
        override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if fromView == "Profile"{
        bottomBtn.isUserInteractionEnabled = false
        bottomBtn.setTitle("UPDATE", for: .normal)
        bottomBtn.alpha = 0.5
        }
        else{
        bottomBtn.setTitle("SIGN UP", for: .normal)
        bottomBtn.alpha = 1
                }
        wsManager = WebserviceManager()
        self.navigationItem.title = "Notification Categories"
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Roboto-Medium", size: 14)!]
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.SetBackBarButtonCustom()
        print("all item are \(items)")
    }
    //MARK- Navigation Back Button
    @IBAction func actionSaveCat(_ sender: Any) {
        print(selectedCategoryArray)
        if (selectedCategoryArray.isEmpty){
            FTIndicator.showToastMessage("Select atlest one Category")
            return
            
        }
        else{
            if fromView == "Profile"{
            self.updateCategory()
            
            }
            else{
            FTIndicator.showProgress(withMessage: "Registering....")
                delegate?.selectedCatagoryArray(array: selectedCategoryArray as NSArray)
            }
        }
      //  self.onClcikBack()
    }
    func updateCategory(){
        FTIndicator.showProgress(withMessage: "loading..")
        let  catStr = selectedCategoryArray.joined(separator: ",")
        wsManager.updateCategory(catStr, completionHandler:{(sucess,message)-> Void in
            if sucess{
                FTIndicator.dismissProgress()
                FTIndicator.showToastMessage(message)
                Singleton.sharedInstance.user.category = catStr
                var dict = UserDefaults.standard.object(forKey: "user")  as! [String : String]
                dict.removeValue(forKey: "category")
                dict["category"] = catStr as String
                self.bottomBtn.isUserInteractionEnabled = false
                 self.bottomBtn.alpha = 0.5
              }
            else{
                FTIndicator.dismissProgress()
                FTIndicator.showToastMessage(message)
            }
        })
    }
    @IBAction func hideDetailView(_ sender: Any) {
        self.popUpDetailView.removeFromSuperview()
    }
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
    func  detialClicK(_ sender: UIButton){
        let item = items[sender.tag]
        guard let detail = item.categoryDesc, let name = item.categoryName else {
            return
        }
        self.setUpDetailView(heading:name, detail: detail)
    }
    //MARK:- Download Images
    func downloadImageForItem(_ item: CategoryModel, indexPath: IndexPath) {
        let str: String = item.categoryImageUrl!
        print(str)
        
        wsManager.downloadImage2(URL(string: str), completionHandler: { (image) -> Void in
         DispatchQueue.main.async(execute: { () -> Void in
                if let cell = self.collectionView.cellForItem(at: indexPath) as?CategoryCell {
                    cell.activityIndicator.stopAnimating()
                    cell.activityIndicator.isHidden = true
                    cell.categoryImageView.image = image
                }
            })
        })
    }
    
}
// MARK: - UICollectionViewDataSource
extension SelectMultipleCategory:UICollectionViewDataSource{
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    //2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    //3
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
        cell.detailBtn.addTarget(self, action: #selector(self.detialClicK), for: .touchUpInside)
        cell.detailBtn.tag = indexPath.row
        let item = items[(indexPath as NSIndexPath).row]
        if fromView == "Profile"{
            if selectedCategoryArray.contains(item.categoryId!){
                cell.selectCatImageView.isHidden = false
            }
        }
        cell.categoryNameLbl.text =  item.categoryName
        cell.categoryImageView.image = nil
        cell.activityIndicator.startAnimating()
         cell.activityIndicator.isHidden = false
        if collectionView.isDragging == false && collectionView.isDecelerating == false {
             downloadImageForItem(item, indexPath: indexPath)
            }
        
        return cell
    }
    
}
// MARK: - UICollectionViewDelegate
extension SelectMultipleCategory:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                                     didSelectItemAt indexPath: IndexPath) {
        if fromView == "Profile"{
        bottomBtn.alpha = 1
        bottomBtn.isUserInteractionEnabled = true
        }
       let cell = collectionView.cellForItem(at: indexPath) as?CategoryCell
        
            let catID = items[(indexPath as NSIndexPath).row]
        if !(selectedCategoryArray.contains(catID.categoryId!)){
         selectedCategoryArray.append(catID.categoryId!)
        cell?.selectCatImageView.isHidden = false
        }
        else{
            selectedCategoryArray = selectedCategoryArray.filter{$0 != catID.categoryId!}
            cell?.selectCatImageView.isHidden = true
        }
    
        
    }
    }

extension SelectMultipleCategory : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // New code
        //        if indexPath == largePhotoIndexPath {
        //            let flickrPhoto = photoForIndexPath(indexPath)
        //            var size = collectionView.bounds.size
        //            size.height -= topLayoutGuide.length
        //            size.height -= (sectionInsets.top + sectionInsets.right)
        //            size.width -= (sectionInsets.left + sectionInsets.right)
        //            return flickrPhoto.sizeToFillWidthOfSize(size)
        //        }
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

