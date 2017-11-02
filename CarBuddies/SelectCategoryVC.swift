//
//  SelectCategoryVC.swift
//  CarBuddies
//
//  Created by MAC on 21/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
class SelectCategoryVC: UIViewController {
    @IBOutlet weak var headingLblPopUpView: UILabel!
    @IBOutlet weak var cancelBtnPopUpView: UIButton!
    @IBOutlet weak var sendRequestBtnPopUpView: UIButton!
    @IBOutlet weak var okBtnPopUpView: UIButton!
    @IBOutlet weak var catDetailLbl: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet var popUpDetailView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var detail_Lbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate let reuseIdentifier = "CategoryCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
    fileprivate let itemsPerRow: CGFloat = 2
    var items = [CategoryModel]()
    fileprivate var wsManager: WebserviceManager!
    var otherUserId:String?
    var otherUserlicNum: String?
    var selectedCat:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        wsManager = WebserviceManager()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Notification Categories"
      
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Roboto-Medium", size: 14)!]
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.SetBackBarButtonCustom()
        print("the items are\(items)")
    }
    //MARK- Navigation Back Button
   @IBAction func hideDetailView(_ sender: Any) {
          self.popUpDetailView.removeFromSuperview()
    }
    @IBAction func sendCategoryRequest(_ sender: UIButton) {
        self.selectedCat = String(sender.tag)
        self.performSegue(withIdentifier: "segueShowNotification", sender: self)
        self.popUpDetailView.removeFromSuperview()

        }
    @IBAction func action_GotoMessageView(_ sender: Any){
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "segueShowNotification" {
                let vc = segue.destination as! SendNotificationVC
                vc.otherUserID = otherUserId
                vc.selectedCategory = self.selectedCat
            }
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
        self.setUpDetailView(heading:name, detail: detail, forType: "detail")
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
  //  http://nimbyisttechnologies.com/himanshu/car_buddies/api/apis/sendrequest?from_id=18&to_id=19&cat_id=12
}


// MARK: - UICollectionViewDataSource
extension SelectCategoryVC:UICollectionViewDataSource{
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
extension SelectCategoryVC:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let item = items[(indexPath as NSIndexPath).row]
        
        guard let name = item.categoryName else {
            return
        }
        self.setUpDetailView(heading:name,  detail: otherUserlicNum!, forType: "sendRequest")
        self.sendRequestBtnPopUpView.tag = Int(item.categoryId!)!
        
    }
    
}

extension SelectCategoryVC : UICollectionViewDelegateFlowLayout {
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

