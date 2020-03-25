//
//  Feedback.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/01/04.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation

class Feedback {
    
    var seq = -1
    var id = -1
    var uuid = ""
    var auid = ""
    var title = ""
    var category = 0
    var categoryColor = "#000000"
    var date = Date()
    
    
    func toDictionary() -> [String: Any?] {
        var dic: [String: Any?] = [:]
        dic["seq"] = self.seq
        dic["id"] = self.id
//        dic["user_uid"] = self.uuid
//        dic["adviser"] = self.auid
        dic["title"] = self.title
        dic["category"] = self.category
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dic["write_date"] = dateFormatter.string(from: self.date)
        
        return dic
    }
}
