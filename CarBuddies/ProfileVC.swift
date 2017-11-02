//
//  ProfileVC.swift
//  CarBuddies
//
//  Created by MAC on 21/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
class ProfileVC: UIViewController {
    @IBOutlet weak var firstNameTextField    : UITextField!
    @IBOutlet weak var emailTextField        : UITextField!
    @IBOutlet weak var licenceNumberTextField : UITextField!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var editImageBtn: UIButton!
    fileprivate var wsManager: WebserviceManager!
    var picker:UIImagePickerController?=UIImagePickerController()
    var user:User!
    var textFields  : NSArray!
    var boolEditStatus: Bool = false
    var boolEdit: Bool = false
    var boolEditImage: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        wsManager = WebserviceManager()
        self.setUpProfileView()
        self.unEditableView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        wsManager = WebserviceManager()
        self.user = Singleton.sharedInstance.user
        self.textFields = [firstNameTextField,licenceNumberTextField]
        self.navigationItem.title = "Profile"
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Roboto-Medium", size: 14)!]
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.SetBackBarButtonCustom()
    }
    //setUpSimpleView
    func unEditableView(){
        
          //  self.btnEdit.setImage(UIImage(named: "navEdit"), for: .normal)
        editImageBtn.isHidden = true
        emailTextField.alpha = 1
        emailTextField.textColor = UIColor.black
        firstNameTextField.backgroundColor = UIColor.clear
        licenceNumberTextField.backgroundColor = UIColor.clear
        firstNameTextField.isEnabled = false
        emailTextField.isEnabled = false
        licenceNumberTextField.isEnabled = false
        }
    func setUpProfileView(){
        guard let imageUrlString = Singleton.sharedInstance.user.userImageUrl else {
            return
        }
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        wsManager.downloadImage2(URL(string: imageUrlString), completionHandler: { (image) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
               
                self.userImageView.image = image?.resizeImageWith(newSize: CGSize(width: 80, height: 80))
            })
        })
        self.firstNameTextField.text = Singleton.sharedInstance.user.name
        self.emailTextField.text = Singleton.sharedInstance.user.email
        self.licenceNumberTextField.text = Singleton.sharedInstance.user.licenceNumber
        
    }
   //Check username validation
    func isValidInput(Input:String) -> Bool {
        let RegEx = "\\A\\w{5,18}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }

    //setUpEditableView
    func editableView(){
        //Intraction of views
        emailTextField.alpha = 1
        emailTextField.textColor = UIColor.gray
        firstNameTextField.backgroundColor = UIColor.gray
        licenceNumberTextField.backgroundColor = UIColor.gray
        editImageBtn.isHidden = false
        firstNameTextField.isEnabled = true
        licenceNumberTextField.isEnabled = true
        
    }
    //MARK- Navigation Back Button
    func SetBackBarButtonCustom()
    {
        //Back button
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "back"), for: UIControlState())
        btnLeftMenu.addTarget(self, action: #selector(self.onClcikBack), for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let barButtonleft = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButtonleft
        //Right button
        let btnRightMenu: UIButton = UIButton()
        btnRightMenu.setImage(UIImage(named: "edit"), for: UIControlState())
        btnRightMenu.addTarget(self, action: #selector(self.onClcikEdit), for: UIControlEvents.touchUpInside)
        btnRightMenu.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let barButtonRight = UIBarButtonItem(customView: btnRightMenu)
        self.navigationItem.rightBarButtonItem = barButtonRight
    }
    //Navigation back button action
    func onClcikBack()
    {
      _ = self.navigationController?.popViewController(animated: false)
    }
    //Navigation back button action
    func onClcikEdit(_ sender: UIButton)
    {
        
        if ( boolEditStatus == false)
        {
            self.editableView()
            boolEditStatus = true
            
        }
        else
        {
            
            if boolEdit || boolEditImage{
            let alert = UIAlertController(title: "Are You Sure", message:"Want to update changes?", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default){
                UIAlertAction in
                self.unEditableView()
                 self.boolEditStatus = false
                self.boolEdit = false
                self.boolEditImage = false
               
            }
            let cancelAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.update()
            }
            // Add the actions
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            // Present the controller
                self.present(alert, animated: true, completion: nil) }
            else{
                self.unEditableView()
                self.boolEditStatus = false
       }
    }
    }
    func update(){
        for textField in self.textFields as! [UITextField]
        {
            if(textField == self.firstNameTextField){
                if (textField.text?.isEmpty)! {
                    FTIndicator.showToastMessage("Please Enter Display Name")
                    return
                }
                else{
                    if(!self.isValidInput(Input: textField.text!)){
                        FTIndicator.showToastMessage("Invalid Username. Require letter, digits or underscores with minimum five characters")
                        return
                    }
                }
                
            }
            
            if(textField == self.licenceNumberTextField){
                if (licenceNumberTextField.text?.isEmpty)! {
                    FTIndicator.showToastMessage("Please Enter licence number")
                    return
                }
            }
        }
        if boolEditImage{
            FTIndicator.showProgress(withMessage: "Updating..")
            wsManager.updateProfileWithImage(["id":Singleton.sharedInstance.user.id!,"name": self.firstNameTextField.text!,"licence_no": licenceNumberTextField.text!], completionHandler: { (success, message) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if success {
                        FTIndicator.dismissProgress()
                        self.unEditableView()
                        FTIndicator.showToastMessage(message)
                        self.boolEdit = false
                        self.boolEditStatus = false
                        self.boolEditImage = false
                   
                    } else {
                        FTIndicator.dismissProgress()
                        FTIndicator.showToastMessage(message)
                    }
                })
            })
        }
        else if boolEdit{
             FTIndicator.showProgress(withMessage: "Updating..")
            wsManager.updateProfileWithoutImage(firstNameTextField.text!, licenceNumberTextField.text!, completionHandler:  { (success, message) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if success {
                        FTIndicator.dismissProgress()
                        FTIndicator.showToastMessage(message)
                        self.unEditableView()
                        self.boolEdit = false
                        self.boolEditStatus = false
                        self.boolEditImage = false
                        
                    } else {
                        FTIndicator.dismissProgress()
                        FTIndicator.showToastMessage(message)
                    }
                })
            })
        
        }
    }
    @IBAction func editImageAction(_ sender: Any) {
        self.showActionSheet()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowCategory" {
            let vc = segue.destination as! SelectMultipleCategory
             vc.items = Singleton.sharedInstance.categoryArray!
             vc.fromView = "Profile"
            vc.selectedCategoryArray = (Singleton.sharedInstance.user.category?.components(separatedBy: ","))!
            
        }
    }
    //GetUser
    fileprivate func getCategory(_ array: [NSDictionary]) -> [CategoryModel] {
        var items = [CategoryModel]()
        print("array valuse\(array)")
        for item in array{
            let category =  CategoryModel(categoryName: item["name"] as? String ?? "", categoryImageUrl: item["category_image"] as? String ?? "", categoryId: item["id"] as? String ?? "", categoryDesc: item["cat_des"] as? String ?? "")
            items += [category]
            
        }
        return items
    }
    @IBAction func actionShowCategory(_ sender: UIButton){
    self.performSegue(withIdentifier: "segueShowCategory", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func actionLogOut(_ send: UIButton){
        self.logout()
    }
    //MARK:- Logout
    func logout(){
        let alert = UIAlertController(title: "Are You Sure", message:"Want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
        let cancelAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.prepareLogout()
        }
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        // Present the controller
        self.present(alert, animated: true, completion: nil)
    }
    func prepareLogout(){
       
            FTIndicator.showProgress(withMessage: "Requesting..")
         self.wsManager.logout(completionHandler: { (success, message) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if success {
                       
                        FTIndicator.dismissProgress()
                        Singleton.sharedInstance.user = nil
                        
                        let domain = Bundle.main.bundleIdentifier!
                        UserDefaults.standard.removePersistentDomain(forName: domain)
                        UserDefaults.standard.synchronize()
                        
                       //LoginFlow
                        self.pushToLoginScreen()
                    } else {
                        FTIndicator.dismissProgress()
                        let alert = UIAlertController(title: "Unknown Error!", message:"Unable to logout.", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                        // Add the actions
                        alert.addAction(okAction)
                        // Present the controller
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                });
            })
        }
    
    func pushToLoginScreen(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "navMainBase") as! UINavigationController
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.window?.rootViewController = initialViewController
        app.window?.makeKeyAndVisible()
    }}
