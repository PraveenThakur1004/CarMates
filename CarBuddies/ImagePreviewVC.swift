//
//  ImagePreviewVC.swift
//  CarBuddies
//
//  Created by MAC on 03/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
class ImagePreviewVC: UIViewController,UIScrollViewDelegate {
   
    var image: UIImage?
     let imageViewp: UIImageView = UIImageView()
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        let vWidth = self.view.frame.width
        let vHeight = self.view.frame.height
        
        let scrollImg: UIScrollView = UIScrollView()
        scrollImg.delegate = self as UIScrollViewDelegate
        scrollImg.frame = CGRect(x: 0, y: 74, width: vWidth, height: vHeight-70)
            scrollImg.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()
        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 10.0
        scrollImg.backgroundColor = UIColor.clear
        self.view.addSubview(scrollImg)
         imageViewp.frame = CGRect(x: 0, y: 0, width: vWidth, height: scrollImg.frame.size.height)
        imageViewp.layer.cornerRadius = 11.0
        imageViewp.clipsToBounds = false
        imageViewp.image = image
        imageViewp.backgroundColor = UIColor.clear
        imageViewp.contentMode = .scaleAspectFit
        
        scrollImg.addSubview(imageViewp)
    }
    
    //Navigation back button action
 @IBAction   func onClcikBack()
    {
        self.dismiss(animated: false, completion: nil)
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewp
    }
    

    }
