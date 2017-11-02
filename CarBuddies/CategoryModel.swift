//
//  CategoryModel.swift
//  CarBuddies
//
//  Created by MAC on 23/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

class CategoryModel: NSObject {
    //MARK:- Variable
    var categoryName: String?
    var categoryImageUrl: String?
    var categoryId: String?
    var categoryDesc: String?
    
    //MARK:- Intialization
    init( categoryName:String?, categoryImageUrl:String?, categoryId:String?,categoryDesc:String?){
        self.categoryName = categoryName
        self.categoryId = categoryId
        self.categoryImageUrl = categoryImageUrl
        self.categoryDesc = categoryDesc
        
    }
    
    func asCategoryItmDict()-> [String:String]{
  return["name":categoryName!,"id":categoryId!,"category_image":categoryImageUrl!,"cat_des":categoryDesc!]
        
    }
    
    }
