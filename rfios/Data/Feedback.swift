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
    var uuid = ""
    var auid = ""
    var title = ""
    var category = Category()
    var date = Date()
    var complete = -10
    var adviser = User()
    
    init() {
        
    }
    
    init(_ dic: [String:Any]) {
        id = dic["id"] as? Int ?? -1
        uuid = dic["user_uid"] as? String ?? ""
        auid = dic["adviser_uid"] as? String ?? ""
        title = dic["title"] as? String ?? ""
        
        var categories = dic["category"] as! [[String : Any]?]
        categories = categories.filter{ $0 != nil }
        
        if let categoryOpt = categories.first
            , let category = categoryOpt {
            
            self.category = Category(category)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        let dateStr = dic["write_date"] as? String ?? ""
        date = dateFormatter.date(from: dateStr) ?? Date()
        
        complete = dic["complete"] as? Int ?? -10
        adviser = User(dic["adviser"] as? [String : Any] ?? [:])
    }
    
    func toDictionary() -> [String: Any?] {
        var dic: [String: Any?] = [:]
        dic["id"] = self.id
        dic["title"] = self.title
        dic["category"] = self.category.id
        dic["adviser"] = self.adviser.uid
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dic["write_date"] = dateFormatter.string(from: self.date)
        
        return dic
    }
}
