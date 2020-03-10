//
//  User.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/01/13.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation

struct User {
    var portrait = ""
    var introduction = ""
    var nickname = ""
    var email = ""
    
    init(_ dic: [String:String]?) {
        portrait = dic?["portrait"] ?? ""
        introduction = dic?["introduction"] ?? ""
        nickname = dic?["nickname"] ?? "NO NICKNAME"
        email = dic?["email"] ?? "NO EMAIL"
    }
}
