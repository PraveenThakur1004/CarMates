//
//  User.swift
//  CarBuddies
//
//  Created by MAC on 20/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import Foundation

class User: NSObject {
   //MARK:-Variable and Constant
    var id: String?;
    var name: String?;
    var email: String?;
    var password: String?;
    var userImageUrl: String?;
    var userImageData: Data?
    var licenceNumber: String?;
    var category: String?
    //MARK:- Initialization
    init(name: String, email: String, licenceNumber:String, category:String, password: String) {
        self.name = name;
        self.email = email;
        self.password = password;
        self.licenceNumber = licenceNumber
        self.category = category
    }
    init(id:String,userImageUrl:String,name: String, email: String, licenceNumber:String, category:String, password: String){
        self.id = id
        self.userImageUrl = userImageUrl
        self.name = name;
        self.email = email;
        self.password = password;
        self.licenceNumber = licenceNumber
        self.category = category
    }
    
    func asDictionary() -> [String: String] {
          return ["name": name!, "email": email!, "password": password!,  "licence_no": licenceNumber!,  "category": category!];
    }
    func asreponseDictionary() -> [String: String] {
        return ["name": name!, "email": email!, "password": password!,  "licence_no": licenceNumber!,  "category": category!,"id":id!,"person_image":userImageUrl!];
    }
   func asQueryString() -> String {
         var str = "&name=\(name!)&email=\(email!)&password=\(password!)&licence_no=\(licenceNumber!)&category=\(category!)";
             if(Singleton.sharedInstance.userImageData != nil){
                  let encodedStr = Singleton.sharedInstance.userImageData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
                   str += "&person_image=" + encodedStr;
              }
             else{
                str += "&person_image="
    }
               if(Singleton.sharedInstance.carImageData != nil){
                  let encodedStr = Singleton.sharedInstance.carImageData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
                    str += "&vehicle_image=" + encodedStr;
                }
               else{
                str += "&vehicle_image="
    }
        return str
    }
    
    
    
    
}

