//
//  Feedback.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/01/04.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation

struct Feedback {
    
    var seq = -1
    var title = ""
    var category = 0
    var date: Date?
    var friend: String = ""
    
    func toDictionary() -> [String: Any?] {
        var dic: [String: Any?] = [:]
        dic["seq"] = self.seq
        dic["category_title"] = self.title
        
        return dic
    }
}
