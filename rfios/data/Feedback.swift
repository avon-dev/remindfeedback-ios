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
    @objc dynamic var date: Date? = nil
    
    override class func primaryKey() -> String? {
      return "id"
    }
    
    
    func toDictionary() -> [String: Any?] {
        var dic: [String: Any?] = [:]
        dic["seq"] = self.seq
        dic["id"] = self.id
        dic["user_uid"] = self.uuid
        dic["adviser_uid"] = self.auid
        dic["category"] = self.category
        dic["write_date"] = self.date
        
        return dic
    }
}

extension Feedback: IdentifiableType {
  var identity: Int {
    return self.isInvalidated ? 0 : id
  }
}
