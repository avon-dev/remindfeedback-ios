//
//  Category.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/12/07.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation

struct Category {
    
    var id = 0
    var title = "기본"
    var color = "#000000"
    
    init() {
        
    }
    
    init(_ dic: [String:Any]) {
        id = dic["category_id"] as? Int ?? -1
        title = dic["category_title"] as? String ?? ""
        color = dic["category_color"] as? String ?? "#000000"
    }
    
    func toDictionary() -> [String: Any?] {
        var dic: [String: Any?] = [:]
        dic["category_id"] = self.id
        dic["category_title"] = self.title
        dic["category_color"] = self.color
        
        return dic
    }
}
