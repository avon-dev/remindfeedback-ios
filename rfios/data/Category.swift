//
//  Category.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/12/07.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation

struct Category {
    
    var seq = -1
    var id = -1
    var title = ""
    var color = "#000000"
    
    init(title: String = "", color: String = "#000000") {
        self.title = title
        self.color = color
    }
    
    func toDictionary() -> [String: Any?] {
        var dic: [String: Any?] = [:]
        dic["seq"] = self.seq
        dic["id"] = self.id
        dic["category_title"] = self.title
        dic["category_color"] = self.color
        
        return dic
    }
}
