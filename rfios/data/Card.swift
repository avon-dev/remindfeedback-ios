//
//  Card.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/02/04.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

class Card: Object {
    
    @objc dynamic var seq = -1
    @objc dynamic var id = -1
    @objc dynamic var title = ""
    @objc dynamic var date = Date()
    @objc dynamic var content = ""
    @objc dynamic var feedbackID = -1
    
    override class func primaryKey() -> String? {
      return "seq"
    }
    
    
    func toDictionary() -> [String: Any?] {
        var dic: [String: Any?] = [:]
        dic["seq"] = self.seq
        dic["id"] = self.id
        dic["board_title"] = self.title
        dic["board_content"] = self.content
        dic["feedback_id"] = self.feedbackID
        
        return dic
    }
}
