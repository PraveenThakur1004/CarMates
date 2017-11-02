//
//  SignUpVC.swift
//
//
//  Created by jatin-pc on 9/12/17.
//
//

import  UIKit
import  AVFoundation
import  Photos
import  ZWIntroductionViewController
import  FTIndicator
class SignUpVC: UIViewController {
    //MARK:- IBoutlet
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var firstNameTextField    : UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var emailTextField        : UITextField!
    @IBOutlet weak var passwordTextField        : UITextField!
    @IBOutlet weak var reEnterPasswordTextField : UITextField!
    @IBOutlet weak var licenceNumberTextField : UITextField!
    @IBOutlet weak var submitButton : UIButton!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var btnCheckbox: UIButton!
    @IBOutlet weak var howItWorkView: UIView!
    //MARK:- Variable
    var selectedCatageoryArray = [String]()
    var iconPassClick : Bool!
    var iconConfirmPassClick : Bool!
    var cartegoryList = [CategoryModel]()
    var introductionView: ZWIntroductionView!
    //MARK:- Variables and Constants
    var categoryArray: NSMutableArray!
    var checkTermConditon : Bool!
    let wsManager = WebserviceManager()
    let textValidationManager = TextFieldValidationsManager()
    let alertControlerManager = AlertControllerManager()
    var textFields  : NSArray!
    var errorArrow : UIImageView!
    var picker:UIImagePickerController?=UIImagePickerController()
    var selectedPhoto = 0
    let buttonAttributes : [String: Any] = [
        NSFontAttributeName : UIFont.systemFont(ofSize: 18),
        NSForegroundColorAttributeName : UIColor.blue,
        NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
    //MARK - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        iconPassClick = false
        iconConfirmPassClick = false
        self.cartegoryList = Singleton.sharedInstance.categoryArray!
        checkTermConditon = false
        self.textFields = [self.firstNameTextField, self.emailTextField, self.passwordTextField, self.reEnterPasswordTextField,self.licenceNumberTextField, self.reEnterPasswordTextField];
        self.errorArrow = UIImageView(image: UIImage(named:"error_arrow"));
         self.bottomView.backgroundColor =  UIColor.black.withAlphaComponent(0.3)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    //MARK- IBAction's
    //Show how it works slider
    @IBAction func showHowItWorks(_ sender: Any) {
        // Added Introduction View
        self.introductionView = self.simpleIntroductionView()
        self.view.addSubview(self.introductionView)
       // if self.introductionView.
        //Skip button
        let btnCancel: UIButton = UIButton()
        btnCancel.setTitle("Skip", for: .normal)
        btnCancel.setTitleColor(UIColor.black, for: .normal)
        btnCancel.titleLabel!.font = UIFont(name: "Roboto-Medium" , size: 18)
        btnCancel.addTarget(self, action: #selector(self.onClcikEdit), for: UIControlEvents.touchUpInside)
        btnCancel.frame = CGRect(x: self.view.frame.size.width - 80, y:25, width: 44, height: 44)
        self.view.addSubview(btnCancel)
        self.view.bringSubview(toFront: btnCancel)
//        self.introductionView!.didSelectedEnter = {
//            self.introductionView!.removeFromSuperview()
//            self.introductionView = nil;
//            
//        }
    }
    //Hide intorduction view
    func onClcikEdit(sender:UIButton){
        self.introductionView!.removeFromSuperview()
        self.introductionView = nil;
        sender.removeFromSuperview()
    }
    // Example 1 : Simple
    func simpleIntroductionView() -> ZWIntroductionView {
        let backgroundImageNames = ["how1","how2", "how3","how4","how5"]
        let enterButton = UIButton()
       let attributeString = NSMutableAttributedString(string: "For More tutorial click here",
                                                        attributes: buttonAttributes)
        enterButton.setAttributedTitle(attributeString, for: .normal)
        enterButton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        let vc = ZWIntroductionView(coverImageNames:backgroundImageNames, backgroundImageNames: backgroundImageNames, button: enterButton)!
        return vc
        
       
    }
    
    func pressButton(button: UIButton) {
        guard let url = URL(string: "https://www.youtube.com/watch?v=Dh64WgIvCTM&feature=youtu.be") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            FTIndicator.showProgress(withMessage: "loading")
            UIApplication.shared.open(url, options: [:], completionHandler:
                { (sucess) -> Void in
                    FTIndicator.dismissProgress()
                    })
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func action_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func checkAction(_ sender: UIButton) {
        // Instead of specifying each button we are just using the sender (button that invoked) the method
        switch sender.tag {
        case 100:
            if ( iconPassClick == false)
            {
                sender.setImage(UIImage(named: "eyeopned"), for: .normal)
                iconPassClick = true
                passwordTextField.isSecureTextEntry = false
            }
            else
            {
                sender.setImage(UIImage(named: "eyeclosed"), for: .normal)
                iconPassClick = false
                passwordTextField.isSecureTextEntry = true
            }
        case 101:
            if ( iconConfirmPassClick == false)
            {
                sender.setImage(UIImage(named: "eyeopned"), for: .normal)
                iconConfirmPassClick = true
                reEnterPasswordTextField.isSecureTextEntry = false
            }
            else
            {
                sender.setImage(UIImage(named: "eyeclosed"), for: .normal)
                iconConfirmPassClick = false
                reEnterPasswordTextField.isSecureTextEntry = true
            }
        default:
            break
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowCategory" {
            let vc = segue.destination as! SelectMultipleCategory
            vc.items = cartegoryList
            vc.delegate = self
            vc.fromView = "SighUp"
        }
    }
    //MARK:-IBAction
    @IBAction func registerUser(_ sender: UIButton) {
        
        //
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
            if(textField == self.emailTextField){
                if (emailTextField.text?.isEmpty)! {
                    FTIndicator.showToastMessage("Please Enter Email")
                    return
                }
                else{
                    if(!CommonUtility.isValidEmail(textField.text!)){
                        FTIndicator.showToastMessage("Please Enter Valid Email")
                        return
                    }
                }
            }
            if(textField == self.passwordTextField){
                if (passwordTextField.text?.isEmpty)! {
                    FTIndicator.showToastMessage("Please Enter password")
                    return
                }
                    
                else{
                    if((textField.text?.characters.count)! < 6){
                        FTIndicator.showToastMessage("Password is not long enough")
                        return
                    }
                }
            }
            if(textField == self.reEnterPasswordTextField){
                if(self.passwordTextField.text != self.reEnterPasswordTextField.text){
                    FTIndicator.showToastMessage("Password mismatch")
                    return
                }
                
                
            }
            if(textField == self.licenceNumberTextField){
                if (licenceNumberTextField.text?.isEmpty)! {
                    FTIndicator.showToastMessage("Please Enter license number")
                    return
                }
            }
        }
        
        guard Singleton.sharedInstance.userImageData != nil
            else {
                FTIndicator.showToastMessage("Please select user image")
                return
        }
        self.performSegue(withIdentifier: "segueShowCategory", sender: self)           }
    
    //MARK:-Action
    //doneEditing
    @IBAction func showImagePicker(_ sender: UIButton) {
        switch  sender.tag {
        case 100:
            selectedPhoto = sender.tag
            self.showActionSheet()
        case 101:
            selectedPhoto = sender.tag
            self.showActionSheet()
        default:
            print("default")
        }
        
    }
    func doneEditingText(_ sender: AnyObject)
    {
        for textField in self.textFields as! [UITextField]
        {
            if(textField.isFirstResponder){
                textField.resignFirstResponder();
                self.navigationItem.rightBarButtonItem = nil;
            }
        }
    }
    
    //textField padding view
    func errorIconImageViewFor(_ _textField: UITextField) -> UIImageView?
    {
        for myView: UIView in _textField.superview!.subviews
        {
            if let iconView = myView as? UIImageView
            {
                return iconView;
            }
        }
        return nil;
    }
    //Check username validation
    func isValidInput(Input:String) -> Bool {
        let RegEx = "\\A\\w{5,18}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    func textFieldShouldEndEditing(_ _textField: UITextField) -> Bool
    {
        return true;
    }
    func textFieldShouldReturn(_ _textField: UITextField) -> Bool {
        let index = self.textFields.index(of: _textField)
        if (self.textFields.count > index+1) {
            let nextField = self.textFields.object(at: index+1) as! UITextField;
            nextField.becomeFirstResponder();
        }else{
            self.navigationItem.rightBarButtonItem = nil;
            _textField.resignFirstResponder();
        }
        return true;
    }
    func textField(_ _textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    
}


