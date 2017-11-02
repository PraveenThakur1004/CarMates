//
//  Profile+Extenstion.swift
//  CarBuddies
//
//  Created by MAC on 28/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import Foundation
import  UIKit
import FTIndicator
extension ProfileVC{
    
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

extension ProfileVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
              boolEditImage = true
              userImageView.image =   chosenImage.resizeImageWith(newSize: CGSize(width: 80, height: 80)) //4
                Singleton.sharedInstance.userImageData = self.converToData(chosenImage)
        
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
extension ProfileVC : UITextFieldDelegate{
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
        boolEdit = true
        return true;
    }
    
}


