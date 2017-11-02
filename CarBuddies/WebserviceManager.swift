//
//  WebserviceManager.swift
//  EdgeMusicNetwork
//
//  Created by Developer II on 6/26/15.
//  Copyright (c) 2015 Angel Jonathan GM. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import FTIndicator

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
//http://nimbyisttechnologies.com/himanshu/car_buddies/api/apis/generateNoti?user_id&title&message
//MARK:-BaseUrls
let baseUrl = "http://nimbyisttechnologies.com/himanshu/car_buddies/api/apis/"
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class WebserviceManager: NSObject{
    //MARK:- Constant BaseUrl+taskUrl
    //New
    fileprivate let failedURLMessage = "cannot access server's URL"
 
    //Basic
    let registerUserURL = baseUrl + "registerUser?"
    let userLoginURL = baseUrl + "login?"
    let userPasswordURL = baseUrl + "forgetPassword?"
    let userUpdateProfile = baseUrl + "updateProfile?"
    let changePasswordURL = baseUrl + "updatePassword?"
    let updateDevice = baseUrl + "updateDevice?"
    let logoutURL = baseUrl + "logout?"
    
    //Others
    let searchlicence = baseUrl + "searchlicence?"
    let categoryList = baseUrl + "categorylist"
    let sendRequest = baseUrl + "sendrequest?"
    let acceptRequest = baseUrl + "acceptreq?"
    let rejectRequest = baseUrl + "rejectreq?"
    let allrequestsReceivedList = baseUrl + "requestrecieved?"
    let allSentRequestList = baseUrl + "requestsent?"
    let allrecentChatList = baseUrl + "inboxUsers?"
    let allNotificationURL = baseUrl + "notificationlist?"
    let deleteChatURL = baseUrl + "deleteRequest?"
    let fireNotificationURL = baseUrl + "generateNoti?"
    //MARK:-Almofire post request
    // MARK: UPLOADTOSERVER
    func uploadTaskFor(URLString : String , parameters : [String : String] , filesArray : NSArray, showIndicator : Bool , completion: @escaping (_ success: [String : AnyObject]) -> Void){
        
        if Connectivity.isConnectedToInternet{
            Alamofire.upload(
                multipartFormData: { MultipartFormData in
                    for (key, value) in parameters {
                        MultipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
            MultipartFormData.append(Singleton.sharedInstance.userImageData!, withName: "person_image", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                    }, to: URLString) { (result) in
              switch(result) {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let json = response.result.value
                        completion(json as! [String : AnyObject])
                    }
                    break;
                case .failure(_):
                    FTIndicator.showError(withMessage:"Unable to find the result")
                    break;
                }
            }
        }else{
            FTIndicator.showError(withMessage:"Network no available")
        }
        
    }
    func alamofirePost(parameter : NSDictionary , urlString : String, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        if Connectivity.isConnectedToInternet{
            Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default , headers: nil).responseJSON { (response:DataResponse<Any>) in
                print(response.result)
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        let dict  =  response.result.value as! NSDictionary
                        completionHandler(dict, nil)
                        print(dict)
                        
                        
                    }
                    break
                case .failure(_):
                    completionHandler(nil, response.result.error as NSError?)
                    break
                }
            }
        }
        else{
            FTIndicator.showError(withMessage:"Network no available")
        }
    }
    func alamofireGet(urlString:String,completionHandler:@escaping(AnyObject)-> ()){
        if Connectivity.isConnectedToInternet{
            Alamofire.request(urlString).responseJSON{ response in // method defaults to `.get`
                debugPrint(response)
                print(response)
                switch(response.result){
                case .success(_):
                    if let JSON = response.result.value {
                        
                        completionHandler(JSON as AnyObject)
                    }
                    break
                case .failure(_):
                    completionHandler((response.result.error as NSError?)!)
                    break
                }
            }}
        else{
            FTIndicator.showError(withMessage:"Network no available")
        }
    }
    
    
    
    
    //New Api's
    //Get Category
    func getCategory( completionHandler closure: @escaping (_ categoryList: [CategoryModel], _ success: Bool, _ message: String?) -> Void) {
        if URL(string: categoryList) != nil {
            let queryString = categoryList
            self.alamofireGet(urlString: queryString,  completionHandler: { result in
                var success = false
                var message: String?
                var category = [CategoryModel]()
                let status = result["response"] as? String
                if  status == "1" {
                    success = true
                    let data  = result["data"] as? [NSDictionary]
                   if ((data?.count) != nil){
                        category = self.getCategory(data!)}
                    message = result["mesg"] as? String;
                }
                else {
                    let status = result["response"] as? String
                    print(status )
                    message = result["mesg"] as? String;
                }
                closure( category, success ,message);
            })
        }
    }
    
    //MARK:- Login and Register
    func registerUser(_ user: User, completionHandler closure: @escaping (_ user: User?,_ success: Bool, _ message: String?) -> Void)  {
        self.uploadTaskFor(URLString: registerUserURL, parameters: user.asDictionary(), filesArray: [], showIndicator: false, completion:  { (result) -> Void in
            var success = false
            var message: String?
            var user: User?
            let status = result["response"] as? String
            if  status == "1" {
                success = true
                let dict  = result["data"] as? [String: AnyObject]
                user = self.getUser(dict!)
                message = result["mesg"] as? String;
            }
            else {
                message = result["mesg"] as? String;
            }
            closure(user,success,message );
        })
        
    }
   // http://nimbyisttechnologies.com/himanshu/car_buddies/api/apis/updateDevice?user_id=2&deviceToken=qqq&deviceType=andriod
    func updateToken(_ devicetoken: String, completionHandler closure: @escaping ( _ success: Bool) -> Void) {
        if URL(string: updateDevice) != nil {
            let userId = Singleton.sharedInstance.user.id
            
            let queryString = updateDevice + "user_id=\(userId!)"  + "&deviceType=ios" + "&deviceToken=\(String(describing: Singleton.sharedInstance.deviceToken!))" ;
            print(queryString)
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false
                let status = result?["response"] as! String
                if  status == "1" {
                    success = true
                   
                }
                else {
                    success = false
                }
                closure(success );
            })
        }
    }
   //http://nimbyisttechnologies.com/himanshu/car_buddies/api/apis/generateNoti?user_id&title&message
    func fireNotification(_ user_id: String,title:String,message:String, completionHandler closure: @escaping ( _ success: Bool) -> Void) {
        if URL(string: fireNotificationURL) != nil {
            let userId = Singleton.sharedInstance.user.id
             let queryString = fireNotificationURL + "user_id=\(userId!)"  + "&title=\(title)" + "&message=\(message)" ;
            print(queryString)
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false
                let status = result?["response"] as! String
                if  status == "1" {
                    success = true
                    
                }
                else {
                    success = false
                }
                closure(success );
            })
        }
    }
    
   //login
    func login(_ email: String, password: String, completionHandler closure: @escaping (_ user: User?, _ success: Bool, _ message: String?) -> Void) {
        if URL(string: userLoginURL) != nil {
            let email = CommonUtility.encodeString(email);
            let password = CommonUtility.encodeString(password);
            let queryString = userLoginURL + "&email=\(email)" + "&pass=\(password)" + "&type=2" + "&deviceType=ios" + "&deviceToken=\(String(describing: Singleton.sharedInstance.deviceToken!))" ;
            print(queryString)
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false
                var message: String?
                var user: User?
                let status = result?["response"] as! String
                if  status == "1" {
                    success = true
                    let dict  = result?["data"] as? [String: AnyObject]
                     user = self.getUser(dict!)
                    message = "User logged in successfully";
                }
                else {
                    let status = result?["response"] as! String
                    print(status )
                    message = result?["mesg"] as? String;
                }
                closure( user, success ,message);
            })
        }
    }
  //  http://nimbyisttechnologies.com/himanshu/car_buddies/api/apis/updateProfile?id=17&name=himanshu updated&licence_no=4444&category=11,12
    //MARK:- Login and Register
    func updateProfileWithImage(_ dict:[String: String]  , completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void)  {
        self.uploadTaskFor(URLString: userUpdateProfile, parameters: dict, filesArray: [], showIndicator: false, completion:  { (result) -> Void in
            var success = false
            var message: String?
            var user: User?
            let status = result["response"] as? String
            if  status == "1" {
                success = true
                let dict  = result["data"] as? [String: AnyObject]
                Singleton.sharedInstance.user = nil
                UserDefaults.standard.removeObject(forKey: "user")
                user = self.getUser(dict!)
                Singleton.sharedInstance.user = user
                let dictUser = user?.asreponseDictionary()
                UserDefaults.standard.set(dictUser, forKey: "user")
                UserDefaults.standard.synchronize()
                message = result["mesg"] as? String;
            }
            else {
                message = result["mesg"] as? String;
            }
            closure(success,message);
        })
        
    }
    //Update Profile without Image
    func updateProfileWithoutImage(_ name:String, _ licenceNumber: String,  completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string: userUpdateProfile) != nil {
            guard let id = Singleton.sharedInstance.user.id else {
                FTIndicator.showProgress(withMessage: "Invalid user")
                return }
            let queryString = userUpdateProfile + "id=\(id)" + "&name=\(name)"  + "&licence_no=\(licenceNumber)" ;
            print(queryString)
           self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false;
                var message: String?;
                var user: User?
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true;
                    let dict  = result?["data"] as? [String: AnyObject]
                    Singleton.sharedInstance.user = nil
                    UserDefaults.standard.removeObject(forKey: "user")
                    user = self.getUser(dict!)
                    Singleton.sharedInstance.user = user
                    let dictUser = user?.asreponseDictionary()
                    UserDefaults.standard.set(dictUser, forKey: "user")
                    UserDefaults.standard.synchronize()
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
   //Update Category
    func updateCategory(_ selectedCategory:String,  completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string: userUpdateProfile) != nil {
            guard let id = Singleton.sharedInstance.user.id else {
                FTIndicator.showProgress(withMessage: "Invalid user")
                return }
            let queryString = userUpdateProfile + "id=\(id)" + "&category=\(selectedCategory)"  ;
            print(queryString)
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false;
                var message: String?;
                var user: User?
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true;
                    let dict  = result?["data"] as? [String: AnyObject]
                    Singleton.sharedInstance.user = nil
                    UserDefaults.standard.removeObject(forKey: "user")
                    user = self.getUser(dict!)
                    Singleton.sharedInstance.user = user
                    let dictUser = user?.asreponseDictionary()
                    UserDefaults.standard.set(dictUser, forKey: "user")
                    UserDefaults.standard.synchronize()
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
    //All Recent Chat
    func allrecentChatList( completionHandler closure: @escaping (_ recentChatArry: [NSDictionary]?, _ success: Bool, _ message: String?) -> Void) {
        if URL(string: allrecentChatList) != nil {
            guard let id = Singleton.sharedInstance.user.id else {
                FTIndicator.showProgress(withMessage: "Invalid user")
                return }
            let queryString = allrecentChatList + "ID=\(String(describing: id))"
            print(queryString)
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false
                var message: String?
                print(result)
                var chatArray: [NSDictionary]?
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true
                    chatArray = result?["data"] as? [NSDictionary]
                    message = result?["mesg"] as? String;
                    // message = "User logged in successfully";
                }
                else {
                    
                    message = result?["mesg"] as? String;
                }
                closure( chatArray, success ,message);
            })
        }
    }
    
   //All Received Requests
  func allReceivedRequests( completionHandler closure: @escaping (_ receivedRequestArray: [NSDictionary]?, _ success: Bool, _ message: String?) -> Void) {
        if URL(string: allrequestsReceivedList) != nil {
            guard let id = Singleton.sharedInstance.user.id else {
                FTIndicator.showProgress(withMessage: "Invalid user")
                return }
            let queryString = allrequestsReceivedList + "user_id=\(String(describing: id))"
            print(queryString)
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false
                var message: String?
                print(result)
                var requestArray: [NSDictionary]?
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true
                    requestArray = result?["data"] as? [NSDictionary]
                    message = result?["mesg"] as? String;
                    // message = "User logged in successfully";
                }
                else {
                    
                    message = result?["mesg"] as? String;
                }
                closure( requestArray, success ,message);
            })
        }
    }
    func allNotificationList( completionHandler closure: @escaping (_ sentRequestArray: [NSDictionary]?, _ success: Bool, _ message: String?) -> Void) {
        if URL(string: allNotificationURL) != nil {
            guard let id = Singleton.sharedInstance.user.id else {
                FTIndicator.showProgress(withMessage: "Invalid user")
                return }
            let queryString = allNotificationURL + "user_id=\(String(describing: id))"
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false
                var message: String?
                print(result)
                var requestArray: [NSDictionary]?
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true
                    requestArray = result?["data"] as? [NSDictionary]
                    message = result?["mesg"] as? String;
                    // message = "User logged in successfully";
                }
                else {
                    
                    message = result?["mesg"] as? String;
                }
                closure( requestArray, success ,message);
            })
        }
    }
    //All sent Requests
    func allSentRequests( completionHandler closure: @escaping (_ sentRequestArray: [NSDictionary]?, _ success: Bool, _ message: String?) -> Void) {
        if URL(string: allSentRequestList) != nil {
            guard let id = Singleton.sharedInstance.user.id else {
                FTIndicator.showProgress(withMessage: "Invalid user")
                return }
            let queryString = allSentRequestList + "user_id=\(String(describing: id))"
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false
                var message: String?
                print(result)
                var requestArray: [NSDictionary]?
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true
                    requestArray = result?["data"] as? [NSDictionary]
                    message = result?["mesg"] as? String;
                   // message = "User logged in successfully";
                }
                else {
                   
                    message = result?["mesg"] as? String;
                }
                closure( requestArray, success ,message);
            })
        }
    }
    //Search licence number
    func searchLicenceNumber(_ licenceNumber:String, completionHandler closure: @escaping (_ searchResult: [NSDictionary]?, _ success: Bool, _ message: String?) -> Void) {
        if URL(string: searchlicence) != nil {
            
            let queryString = searchlicence + "licence_no=\(licenceNumber)"
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false
                var message: String?
                var searchResult: [NSDictionary]?
                let status = result?["response"] as! String
                if  status == "1" {
                    success = true
                    searchResult  = result?["data"] as? [NSDictionary]
                }
                else {
                    let status = result?["response"] as! String
                    print(status )
                    message = result?["mesg"] as? String;
                }
                closure( searchResult, success ,message);
            })
        }
    }
  //Send Request
    func sendRequest(_ otherUserId:String,message:String, forCategories:String, completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string: sendRequest) != nil {
            guard let id = Singleton.sharedInstance.user.id else {
                FTIndicator.showProgress(withMessage: "Invalid user")
                return }
            let messageEn = CommonUtility.encodeString(message)
            let queryString = sendRequest + "from_id=\(id)" + "&to_id=\(otherUserId)" + "&cat_id=\(forCategories)" + "&message=\(messageEn)";
            print(queryString)
            
            
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false;
                var message: String?;
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true;
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
    //Accept Request
    func acceptRequest(_ requestId:String,  completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string: acceptRequest) != nil {
          let queryString = acceptRequest + "request_id=\(requestId)"
           self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false;
                var message: String?;
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true;
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
   func changePassword(_ oldPassword:String,_ newPassword: String,  completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string: changePasswordURL) != nil {
            let userid = Singleton.sharedInstance.user.id
            let queryString = changePasswordURL + "user_id=\(String(describing: userid!))" + "&oldPass=\(oldPassword)" + "&newPass=\(newPassword)"
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false;
                var message: String?;
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true;
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
    //Reject Request
   func rejectRequest(_ requestId:String,  completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string: rejectRequest) != nil {
            let queryString = rejectRequest + "request_id=\(requestId)"
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false;
                var message: String?;
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true;
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
  
        //Logot
  
    func logout(completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string: logoutURL) != nil {
            let userid = Singleton.sharedInstance.user.id
            let queryString = logoutURL + "user_id=\(String(describing: userid!))"
           self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false;
                var message: String?;
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true;
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
    
    //DeleteChat
    func deleteChat(_ toId:String, completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string: deleteChatURL) != nil {
            let userid = Singleton.sharedInstance.user.id
            let queryString = deleteChatURL + "to_id=\(toId)" + "&from_id=\(String(describing: userid!))"
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
           
                var success = false;
                var message: String?;
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true;
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
   
    //ForgotPassword
    func forgotPassword(_ email: String, completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string: userPasswordURL) != nil {
            let queryString = userPasswordURL  +  "&email=\(email)" + "&type=\("2")" ;
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false
                var message: String?
                let status = result?["response"] as! String
                if  status == "1" {
                    success = true
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
    //MARK:-ImageDownload
    func downloadImage2(_ url: URL?, completionHandler closure: @escaping (_ image: UIImage?) -> Void) {
        if let url = url {
            let URLCache = Foundation.URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "ImageDownloadCache");
            let session = URLSession.shared;
            let urlRequest = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30.0);
            if let response = URLCache.cachedResponse(for: urlRequest) {
                let image = UIImage(data: response.data)
                closure(image);
                return;
            }
            let dataTask = session.dataTask(with: urlRequest as URLRequest) {data,response,error in
                DispatchQueue.main.async {
                    var image: UIImage?
                    if data?.count > 0 {
                        image = UIImage(data: data!);
                    }else{
                        image = UIImage(named: "logo_small");
                    }
                    closure(image)
                }
            }
            dataTask.resume()
        } else {
            closure(nil)
        }
    }
    
    //Private
    //GetUser
    fileprivate func getUser(_ dict: [String: AnyObject]) -> User {
        
        let user = User(id: dict["id"] as? String ?? "", userImageUrl: dict["person_image"] as? String ?? "",name: dict["name"] as? String ?? "", email: dict["email"] as? String ?? "", licenceNumber: dict["licence_no"] as? String ?? "", category: dict["category"] as? String ?? "", password: dict["password"] as? String ?? "")
            return user
    }
    //Private
    //GetUser
    fileprivate func getCategory(_ array: [NSDictionary]) -> [CategoryModel] {
        var items = [CategoryModel]()
        
        for item in array{
            let category =  CategoryModel(categoryName: item["name"] as? String ?? "", categoryImageUrl: item["category_image"] as? String ?? "", categoryId: item["id"] as? String ?? "", categoryDesc: item["cat_des"] as? String ?? "")
            items += [category]
            
        }
        return items
    }
}
