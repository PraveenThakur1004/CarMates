//
//  ForgetPasswordVC.swift
//  SnobbiMerchantSide
//
//  Created by jatin-pc on 9/12/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
class ForgetPasswordVC: UIViewController {
    //IBoutlet
    @IBOutlet weak var emailTextField:UITextField!
    //MARK:- Variables and Constants
    let wsManager = WebserviceManager()
    let textValidationManager = TextFieldValidationsManager()
    let alertControlerManager = AlertControllerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        //SetUp NavigationBar
//        self.navigationController?.navigationBar.tintColor = UIColor.red
//        self.navigationController?.navigationBar.topItem?.title = "FORGET PASSWORD"
//        //Set NavigationBar transparent
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
//        //navigationBar title color
//        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
//        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    @IBAction func action_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func actionFogotPassword(_ sender: Any) {
        let forgotPasswordEmailString = emailTextField.text!
        
        if self.textValidationManager.isContentValid(forgotPasswordEmailString) == .ok {
            if self.textValidationManager.isValidEmail(forgotPasswordEmailString) == true {
                FTIndicator.showProgress(withMessage: "loading....")
               
                self.wsManager.forgotPassword(forgotPasswordEmailString, completionHandler: { (success, message: String?) -> Void in
                    if success {
                         FTIndicator.dismissProgress()
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.present(self.alertControlerManager.alertForServerError("Forgot password info", errorMessage: message!), animated: true, completion: nil)
                        })
                    } else {
                         FTIndicator.dismissProgress()
                        DispatchQueue.main.async(execute: { () -> Void in
                            if let message = message {
                                self.present(self.alertControlerManager.alertForServerError("Forgot password info", errorMessage: message), animated: true, completion: nil)
                            } else {
                                self.present(self.alertControlerManager.alertForServerError("Forgot password info", errorMessage: "Something went wrong. Please try again"), animated: true, completion: nil)
                            }
                        });
                    }
                })
                
            } else {
                let alert =  self.alertControlerManager.alertForCustomMessage("Forgot password info", errorMessage: "Please enter your email in the format someone@example.com", handler: { (AA:UIAlertAction!) -> Void in
                    
                })
                self.present( alert, animated: true, completion:nil)
            }
        } else {
            var errorMessageString = " "
            if self.textValidationManager.isContentValid(forgotPasswordEmailString) == .empty {
                errorMessageString = self.textValidationManager.errorMessageForIssueInTextField("empty",texfieldName:"Forgot password info")
            } else if self.textValidationManager.isContentValid(forgotPasswordEmailString) == .not_MINIMUM {
                errorMessageString = self.textValidationManager.errorMessageForIssueInTextField("minlength",texfieldName:"Forgot password info")
            } else if self.textValidationManager.isContentValid(forgotPasswordEmailString) == .not_MAXIMUM {
                errorMessageString = self.textValidationManager.errorMessageForIssueInTextField("maxlength",texfieldName:"Forgot password info")
            }
            let alert =  self.alertControlerManager.alertForCustomMessage("", errorMessage: errorMessageString, handler: { (AA:UIAlertAction!) -> Void in
                
            })
            self.present( alert, animated: true, completion:nil)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func responseForSendingEmail (){
        let alertController = UIAlertController(title: "Success!", message:
            "Email sent to retrive password!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
//MARK:- textField and almofire parameter endcoding
extension ForgetPasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        textField.borderStyle = UITextBorderStyle.none
        return true
    }
}

