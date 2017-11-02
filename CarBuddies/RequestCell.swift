//
//  RequestCell.swift
//  CarBuddies
//
//  Created by MAC on 21/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {

    ////MARK:- IBOutlet
    @IBOutlet weak var  thumbnailImageView: UIImageView!
    @IBOutlet weak var  userNameLabel: UILabel!
    @IBOutlet weak var  timeLabel: UILabel!
    @IBOutlet weak var  licenceNumberlbl: UILabel!
    @IBOutlet weak var  activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var  shadowView: UIView!
    ////MARK:- IBInspectable
    @IBInspectable var userImage: UIImage? {
        didSet {
            thumbnailImageView.image = userImage
        }
    }
    @IBInspectable var name: String?
        {
        didSet{
            userNameLabel.text = name
        }
    }
    @IBInspectable var time: String?
        {
        didSet{
            timeLabel.text = time
        }
    }
    @IBInspectable var licence: String?
        {
        didSet{
            licenceNumberlbl.text = licence
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = thumbnailImageView.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        thumbnailImageView.addSubview(blurEffectView)
        
        // Initialization code
        // shadowView.layer.shadowOpacity = 0.7
        // shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        // shadowView.layer.shadowRadius = 15.0
        // shadowView.layer.shadowColor = UIColor.darkGray.cgColor
        //shadowView.layer.cornerRadius = 4.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
     override func prepareForReuse() {
     thumbnailImageView.image = nil
     timeLabel.text = ""
     licenceNumberlbl.text = ""
     userNameLabel.text = ""
    activityIndicator.stopAnimating()
     }
    
}
