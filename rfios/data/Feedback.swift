//
//  Feedback.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/01/04.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

class Feedback: Object {
    
    @objc dynamic var seq = -1
    @objc dynamic var id = -1
    @objc dynamic var uuid = ""
    @objc dynamic var auid = ""
    @objc dynamic var title = ""
    @objc dynamic var category = 0
    @objc dynamic var categoryColor = "#000000"
    @objc dynamic var date = Date()
    
    override class func primaryKey() -> String? {
      return "seq"
    }
    
    
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

extension Feedback: IdentifiableType {
  var identity: Int {
    return self.isInvalidated ? 0 : id
  }
}

struct SectionOfFeedback {
    var header: String
    var items: [Item]
}

extension SectionOfFeedback: SectionModelType {
    typealias Item = Feedback
    
    init(original: Self, items: [Self.Item]) {
        self = original
        self.items = items
    }
}
