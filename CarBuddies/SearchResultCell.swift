//
//  SearchResultCell.swift
//  CarBuddies
//
//  Created by MAC on 21/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    ////MARK:- IBOutlet
    @IBOutlet weak var  thumbnailImageView: UIImageView!
    @IBOutlet weak var  licencePlateNumber: UILabel!
    
    @IBOutlet weak var  shadowView: UIView!
    ////MARK:- IBInspectable
    @IBInspectable var tumbImage: UIImage? {
        didSet {
            thumbnailImageView.image = tumbImage
        }
    }
    @IBInspectable var licence: String?
        {
        didSet{
            licencePlateNumber.text = licence
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowRadius = 15.0
        shadowView.layer.shadowColor = UIColor.darkGray.cgColor
        shadowView.layer.cornerRadius = 4.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        thumbnailImageView.image = nil
        licencePlateNumber.text = ""
        
      
    }
}
