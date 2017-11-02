//
//  ChangePasswordVC.swift
//  CarBuddies
//
//  Created by MAC on 21/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
class ChangePasswordVC: UIViewController {
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    var textFields: NSArray!
    var iconPassClick : Bool!
    var iconOldPassword : Bool!
    var iconConfirmPassClick : Bool!
    let wsManager = WebserviceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
         iconPassClick = false
         iconOldPassword = false
        iconConfirmPassClick = false
        self.textFields = [self.oldPasswordTextField, self.newPasswordTextField, self.confirmPasswordTextField];
        // Do any additional setup after loading the view.
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    //Navigation back button action
    @IBAction func action_Back(_ sender: UIButton) {
       self.dismiss(animated: false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func checkAction(_ sender: UIButton) {
        // Instead of specifying each button we are just using the sender (button that invoked) the method
        switch sender.tag {
        case 100:
            if ( iconOldPassword == false)
            {
                sender.setImage(UIImage(named: "eyeopned"), for: .normal)
                iconOldPassword = true
                oldPasswordTextField.isSecureTextEntry = false
            }
            else
            {
                sender.setImage(UIImage(named: "eyeclosed"), for: .normal)
                iconOldPassword = false
                oldPasswordTextField.isSecureTextEntry = true
            }
        case 101:
            if ( iconPassClick == false)
            {
                sender.setImage(UIImage(named: "eyeopned"), for: .normal)
                iconPassClick = true
                newPasswordTextField.isSecureTextEntry = false
            }
            else
            {
                sender.setImage(UIImage(named: "eyeclosed"), for: .normal)
                iconPassClick = false
                newPasswordTextField.isSecureTextEntry = true
            }
        case 102:
            if ( iconConfirmPassClick == false)
            {
                sender.setImage(UIImage(named: "eyeopned"), for: .normal)
                iconConfirmPassClick = true
                confirmPasswordTextField.isSecureTextEntry = false
            }
            else
            {
                sender.setImage(UIImage(named: "eyeclosed"), for: .normal)
                iconConfirmPassClick = false
                confirmPasswordTextField.isSecureTextEntry = true
            }
        default:
            break
        }
    }
    @IBAction func actionChangePassword(_ sender: UIButton){
        for textField in self.textFields as! [UITextField]
        {
            
            if(textField == self.oldPasswordTextField){
                if (oldPasswordTextField.text?.isEmpty)! {
                    FTIndicator.showToastMessage("Please Enter  old password")
                    return
                }
                  }
            if(textField == self.newPasswordTextField){
                if (newPasswordTextField.text?.isEmpty)! {
                    FTIndicator.showToastMessage("Please Enter  new password")
                    return
                }
                    
                else{
                    if((textField.text?.characters.count)! < 6){
                        FTIndicator.showToastMessage("Password is not long enough")
                        return
                    }
                }
            }
            if(textField == self.confirmPasswordTextField){
                if(self.newPasswordTextField.text != self.confirmPasswordTextField.text){
                    FTIndicator.showToastMessage("Confirm password mismatch")
                    return
                }
            }
            
        }
        self.changePassword(oldPassword: self.oldPasswordTextField.text, newPassword: self.newPasswordTextField.text)
        
    }
    func changePassword(oldPassword:String?, newPassword:String?){
        FTIndicator.showProgress(withMessage: "Requesting..")
        wsManager.changePassword(oldPassword!,newPassword!, completionHandler:{(sucess,message)-> Void in
            if sucess{
                FTIndicator.dismissProgress()
                self.dismiss(animated: false, completion: nil)
                FTIndicator.showToastMessage(message)
               
            }
            else{
                FTIndicator.dismissProgress()
                FTIndicator.showToastMessage(message)
            }
        })
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
