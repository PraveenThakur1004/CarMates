//
//  HowitVC.swift
//  CarBuddies
//
//  Created by MAC on 04/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
import  ZWIntroductionViewController
class HowitVC: UIViewController {
 var introductionView: ZWIntroductionView!
 let buttonAttributes : [String: Any] = [
        NSFontAttributeName : UIFont.systemFont(ofSize: 18),
        NSForegroundColorAttributeName : UIColor.blue,
        NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "How It Works"
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.introductionView = self.simpleIntroductionView()
        self.view.addSubview(self.introductionView)
       self.SetBackBarButtonCustom()
    }

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
    func SetBackBarButtonCustom()
    {
        //Back button
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "back"), for: UIControlState())
        btnLeftMenu.addTarget(self, action: #selector(self.onClcikBack), for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let barButtonleft = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButtonleft
        
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
    //Navigation back button action
    func onClcikBack()
    {
        _ = self.navigationController?.popViewController(animated: false)
    }

}
