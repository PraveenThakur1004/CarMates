//
//  Constant.swift
//  CarBuddies
//
//  Created by MAC on 20/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import Foundation
import Firebase
struct Constants {
    struct errorMessages {
        static let upRequired : String = "Username and Password are required"
        static let shortName : String = "Username is not long enough"
        static let shortPassword : String = "Password is not long enough"
        static let longName : String = "Username is too long"
        static let longPassword : String = "Password is too long"
    }
    struct firebasePath{
    static let base = Database.database().reference()
    static let child_Chat = "chat"
    static let child_ChatData = "chatData"
    static let child_Messages = "messages"
    static let child_StoreImages = "chatFiles"
    }
}
