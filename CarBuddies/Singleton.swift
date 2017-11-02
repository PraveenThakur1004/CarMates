//
//  Singleton.swift
//  EdgeMusicNetwork
//
//  Created by Developer on 7/28/15.
//  Copyright (c) 2015 Angel Jonathan GM. All rights reserved.
//

import UIKit

let sharedManager : Singleton = Singleton()
class Singleton: NSObject {
    //MARK:-Variable and Constant
     var user : User!
     var category: CategoryModel!
     var deviceToken: String?
     var carImageData: Data?
     var userImageData: Data?
     var userImage:UIImage!
     var otherUserImage:UIImage!
     var categoryArray: [CategoryModel]?
    //MARK:- Initialization
    override init()
    {
       super.init();
    }
    class var sharedInstance : Singleton {
        return sharedManager
    }
        
}
