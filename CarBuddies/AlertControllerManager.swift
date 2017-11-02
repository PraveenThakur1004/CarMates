//
//  AlertControllerManager.swift
//  EdgeMusicNetwork
//
//  Created by Developer II on 7/15/15.
//  Copyright (c) 2015 Angel Jonathan GM. All rights reserved.
//

import UIKit
import StoreKit

class AlertControllerManager: NSObject {
	//MARK:-Alert Controller 
	func alertForCustomMessage(_ errorTitle: String ,errorMessage: String, handler: @escaping (UIAlertAction!)->Void) -> UIAlertController {
		let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: handler))
		return alert
	}

	func alertForServerError(_ errorTitle: String ,errorMessage: String) -> UIAlertController {
		let alert = UIAlertController(title: errorTitle , message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
		return alert
	}

	func alertForEmptyTextField (_ fieldWithError: String) -> UIAlertController {
		let alert = UIAlertController(title: fieldWithError, message:" ", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
		return alert
	}
	func alertForMaxCharacters(_ fieldWithError: String) -> UIAlertController {
		let alert = UIAlertController(title: fieldWithError, message:"Text is too long (maximum is 64 characters)", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
		return alert
	}
	func alertForLessThanMinCharacters(_ fieldWithError: String) -> UIAlertController {
		let alert = UIAlertController(title: fieldWithError, message:"Text is too short (minimum is 6 characters)", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
		return alert
	}
    	func alertForFailInInternetConnection () -> UIAlertController {
		let alert = UIAlertController(title: "Internet'connection needed", message:"To use this App please connect to Internet", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
		return alert
	}
	func alertForNotEmailString () -> UIAlertController {
		let alert = UIAlertController(title: "Invalid email", message:"Please enter your email in the format someone@example.com", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
		return alert
	}
    func alertForSuccesfulSentEmail (_ handler: ((UIAlertAction?)->Void)?)  -> UIAlertController {
        let alert = UIAlertController(title: "Email Sent", message:
            "The email with the recorvery instructions has been sent", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: handler))
        return alert
    }
	func alertForSuccesfulCreatedAccount (_ handler: ((UIAlertAction?)->Void)?)  -> UIAlertController {
		let alert = UIAlertController(title: "Account Created", message:
			"Your account has been created successfully", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: handler))
		return alert
	}
	func alertForSuccesfulSavedChanges (_ handler: ((UIAlertAction?)->Void)?)  -> UIAlertController {
		let alert = UIAlertController(title: "Profile Updated", message:
			"Your information has been updated successfully", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: handler))
		return alert
	}
	
}
