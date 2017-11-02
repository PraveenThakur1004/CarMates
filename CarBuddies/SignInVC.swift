//
//  SignInVC.swift
//  SnobbiMerchantSide
//
//  Created by jatin-pc on 9/12/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
class SignInVC: UIViewController {
    //IBoutlet
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    //MARK:- Variables and Constants
    var iconClick : Bool!
    let wsManager = WebserviceManager()
    let textValidationManager = TextFieldValidationsManager()
    let alertControlerManager = AlertControllerManager()
    //MARK:- ViewLifeCyle
    override func viewDidLoad() {
        super.viewDidLoad()
        iconClick = false
       // self.userNameTextField.text = "carBuddy@mailinator.com"
       // self.passwordTextField.text = "123456"
        self.bottomView.backgroundColor =  UIColor.black.withAlphaComponent(0.3)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    //MARK - Action
    //check textfield entysecure
    @IBAction func checkAction(_ sender: UIButton) {
        if ( iconClick == false)
        {
            sender.setImage(UIImage(named: "eyeopned"), for: .normal)
            iconClick = true
            passwordTextField.isSecureTextEntry = false
        }
        else
        {
            sender.setImage(UIImage(named: "eyeclosed"), for: .normal)
            iconClick = false
            passwordTextField.isSecureTextEntry = true
        }
    }
    //Login Action
    @IBAction func loginToApp(_ sender: UIButton) {
        let userTexFieldState = textValidationManager.isContentValid(userNameTextField.text!)
        let passwordTexFieldState = textValidationManager.isContentValid(passwordTextField.text!)
        if userTexFieldState == TextFieldValidationResult.ok && passwordTexFieldState == TextFieldValidationResult.ok {
            FTIndicator.showProgress(withMessage: "loading...")
            wsManager.login(userNameTextField.text!, password: passwordTextField.text!) { (user, success, message: String?) -> Void in
                if success {
                    FTIndicator.dismissProgress()
                    Singleton.sharedInstance.user = user;
                    UserDefaults.standard.set(user?.email, forKey: "user_email")
                    let dictUser = user?.asreponseDictionary()
                    UserDefaults.standard.set(dictUser, forKey: "user")
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.async(execute: { () -> Void in
                        //MARK MARK MARK
                        self.performSegue(withIdentifier: "segueShowSlider", sender: nil);
                    });
                } else {
                    FTIndicator.dismissProgress()
                    DispatchQueue.main.async(execute: { () -> Void in
                        var msg: String
                        if let message = message {
                            msg = message
                            self.present(self.alertControlerManager.alertForServerError("Login info", errorMessage: msg), animated: true, completion: nil)
                        } else {
                            self.present(self.alertControlerManager.alertForServerError("Login info", errorMessage: "Something went wrong. Please try again"), animated: true, completion: nil)
                        }
                    });
                }
            }
            
        } else {
            let requiredMessage : String = Constants.errorMessages.upRequired
            if userTexFieldState == TextFieldValidationResult.empty {
                self.present(alertControlerManager.alertForEmptyTextField(requiredMessage), animated: true, completion: nil)
                return;
            }
            if passwordTexFieldState == TextFieldValidationResult.empty {
                self.present(alertControlerManager.alertForEmptyTextField(requiredMessage), animated: true, completion: nil)
                return;
            }
            if userTexFieldState == TextFieldValidationResult.not_MINIMUM {
                self.present(alertControlerManager.alertForLessThanMinCharacters(Constants.errorMessages.shortName), animated: true, completion: nil)
                return;
            }
            if passwordTexFieldState == TextFieldValidationResult.not_MINIMUM {
                self.present(alertControlerManager.alertForLessThanMinCharacters(Constants.errorMessages.shortPassword), animated: true, completion: nil)
                return;
            }
            if userTexFieldState == TextFieldValidationResult.not_MAXIMUM {
                self.present(alertControlerManager.alertForMaxCharacters(Constants.errorMessages.longName), animated: true, completion: nil)
                return;
            }
            if passwordTexFieldState == TextFieldValidationResult.not_MAXIMUM {
                self.present(alertControlerManager.alertForMaxCharacters(Constants.errorMessages.longPassword), animated: true, completion: nil)
                return;
            }
        }
    }}
//MARK:- textField Delegates
extension SignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == userNameTextField){
            passwordTextField.becomeFirstResponder();
        }else{
            textField.resignFirstResponder();
        }
        textField.borderStyle = UITextBorderStyle.none
        return true
    }
}
