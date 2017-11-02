//
//  Category+Extension.swift
//  CarBuddies
//
//  Created by MAC on 22/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

extension SelectCategoryVC{
    //MARK:- SetUp Stepper to set time
    func setUpDetailView(heading:String,  detail:String, forType:String){
        if forType == "detail"{
            detailView.isHidden = false
            messageView.isHidden = true
            catDetailLbl.text = "\(detail)"
        }
        else{
            detailView.isHidden = true
            messageView.isHidden = false
         detail_Lbl.text = "Send notification to license number \(detail)?"
        }
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
        
        headingLblPopUpView.text = heading
        
    }
    
}
//MARK:- UIGestureViewDelegates
extension SelectCategoryVC: UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: messageView))!{
            return false
        }
        return true
    }
}
