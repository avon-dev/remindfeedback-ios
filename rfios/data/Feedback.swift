//
//  Feedback.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/01/04.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation

struct Feedback {
    
    var id = -1
    var auid = ""
    var title = ""
    var category = Category()
    var date = Date()
    
    init() {
        
    }
    
    init(_ dic: [String:Any]) {
        id = dic["id"] as? Int ?? -1
        auid = dic["adviser_uid"] as? String ?? ""
        title = dic["title"] as? String ?? ""
        category = dic["category"] as? Category ?? Category()
    }
    
    func toDictionary() -> [String: Any?] {
        var dic: [String: Any?] = [:]
        dic["id"] = self.id
        dic["adviser"] = self.auid
        dic["title"] = self.title
        dic["category"] = self.category.id
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dic["write_date"] = dateFormatter.string(from: self.date)
        
        return dic
    }
}
