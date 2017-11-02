//
//  CategoryCell.swift
//  CarBuddies
//
//  Created by MAC on 21/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var  shadowView: UIView!
    @IBOutlet weak var  detailBtn: UIButton!
    @IBOutlet weak var  categoryNameLbl:UILabel!
    @IBOutlet weak var  categoryImageView: UIImageView!
    @IBOutlet weak var  selectCatImageView: UIImageView!
    @IBOutlet weak var  activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
        shadowView.layer.shadowRadius = 12.0
        shadowView.layer.shadowColor = UIColor.darkGray.cgColor
        shadowView.layer.cornerRadius = 12.0
    }
    override func prepareForReuse() {
     categoryImageView.image = nil
     selectCatImageView.image = nil
     categoryNameLbl.text = ""
    
     }
    
}
