//
//  User.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/01/13.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation
import RxDataSources

struct User {
    var uid = ""
    var portrait = ""
    var introduction = ""
    var nickname = ""
    var email = ""
    var type = -2
    
    init() {
        
    }
    
    init(_ dic: [String:Any]?) {
        uid = dic?["user_uid"] as? String ?? ""
        portrait = dic?["portrait"] as? String ?? ""
        introduction = dic?["introduction"] as? String ?? ""
        nickname = dic?["nickname"] as? String ?? "NO NICKNAME"
        email = dic?["email"] as? String ?? "NO EMAIL"
        type =  dic?["type"] as? Int ?? -2
    }
        
}


