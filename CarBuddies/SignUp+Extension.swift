//
//  SignUp+Extension.swift
//  CarBuddies
//
//  Created by MAC on 22/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
extension SignUpVC{
    
    func showActionSheet(){
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
            
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
            
        }
        // Add the actions
        picker?.allowsEditing = true
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            self .present(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(picker!, animated: true, completion: nil)
        }
        
    }
    func converToData(_ image:UIImage) -> Data{
        let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
        return imageData as Data
    }
}

extension SignUpVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            switch selectedPhoto {
            case 100:
                
                userImageView.image =   chosenImage.resizeImageWith(newSize: CGSize(width: 80, height: 80)) //4
                Singleton.sharedInstance.userImageData = self.converToData(chosenImage)
            // Singleton.sharedInstance.user.userImage = chosenImage
            case 101:
                
                carImageView.image = chosenImage //4
                Singleton.sharedInstance.carImageData = self.converToData(chosenImage)
            // Singleton.sharedInstance.user.carImage = chosenImage
            default:
                break
            }
        } else{
            print("Something went wrong")
        }
        dismiss(animated:true, completion: nil) //5
    }
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
extension SignUpVC:SelectedMultipleCartegoryDelegate{
    func selectedCatagoryArray(array: NSArray) {
        selectedCatageoryArray = array as! [String]
        
        let  catStr = selectedCatageoryArray.joined(separator: ",")
        let user = User(name: firstNameTextField.text!, email: emailTextField.text!, licenceNumber: licenceNumberTextField.text!, category: catStr, password: passwordTextField.text!);
        
        wsManager.registerUser(user, completionHandler: { (user,success, message: String?) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if success {
                    FTIndicator.dismissProgress()
                    Singleton.sharedInstance.user = user
                    UserDefaults.standard.set(user?.email, forKey: "user_email")
                    let dictUser = user?.asreponseDictionary()
                    UserDefaults.standard.set(dictUser, forKey: "user")
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.async(execute: { () -> Void in
                        //MARK MARK MARK
                        FTIndicator.showToastMessage(message)
                        self.performSegue(withIdentifier: "segueShowSlider", sender: nil);
                    });
                } else {
                    FTIndicator.dismissProgress()
                    var msg: String
                    if let message = message {
                        msg = message
                        let alert = UIAlertController(title: "Error", message:msg, preferredStyle: UIAlertControllerStyle.alert)
                        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default , handler: nil)
                        // Add the actions
                        alert.addAction(cancelAction)
                        // Present the controller
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        msg = "This email address is already registered."
                        let alert = UIAlertController(title: "User Account Already Exist", message:msg, preferredStyle: UIAlertControllerStyle.alert)
                        
                        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default , handler: nil)
                        // Add the actions
                        
                        alert.addAction(cancelAction)
                        // Present the controller
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        })
        
    }
    
    
}
