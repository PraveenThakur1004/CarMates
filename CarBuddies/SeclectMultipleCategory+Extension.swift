//
//  SeclectMultipleCategory+Extension.swift
//  CarBuddies
//
//  Created by MAC on 23/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

extension SelectMultipleCategory{
    //MARK:- SetUp Stepper to set time
    func setUpDetailView(heading:String,  detail:String){
        popUpDetailView.frame = self.view.bounds
        self.view.addSubview(popUpDetailView)
        // timeSetupView.fadeIn()
        self.popUpDetailView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.popUpDetailView.isOpaque = true
        // Initialization code
        messageView.layer.shadowOpacity = 0.2
        messageView.layer.shadowOffset = CGSize(width: 3, height: 3)
        messageView.layer.shadowRadius = 15.0
        messageView.layer.shadowColor = UIColor.darkGray.cgColor
        messageView.layer.cornerRadius = 2.0
        detail_Lbl.text = detail
        headinglbl.text = heading
        
    }
    //MARK:- SetUp Stepper to set time
    func setUpDetailView(){
        popUpDetailView.frame = self.view.bounds
        self.view.addSubview(popUpDetailView)
        // timeSetupView.fadeIn()
        self.popUpDetailView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.popUpDetailView.isOpaque = true
        // Initialization code
        messageView.layer.shadowOpacity = 0.2
        messageView.layer.shadowOffset = CGSize(width: 3, height: 3)
        messageView.layer.shadowRadius = 15.0
        messageView.layer.shadowColor = UIColor.darkGray.cgColor
        messageView.layer.cornerRadius = 2.0
        
    }
    
}

//MARK:- UIGestureViewDelegates
extension SelectMultipleCategory: UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: messageView))!{
            return false
        }
        return true
    }
}
public extension UIView{
    /// Fade in a view with a duration
    ///
    /// Parameter duration: custom animation duration
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    /// Fade out a view with a duration
    ///
    /// - Parameter duration: custom animation duration
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
}
