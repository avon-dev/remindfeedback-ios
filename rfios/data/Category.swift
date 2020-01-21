//
//  Category.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/12/07.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

class Category: Object {
    
    @objc dynamic var seq = -1
    @objc dynamic var id = -1
    @objc dynamic var title = ""
    @objc dynamic var color = "#000000"
    
    override static func primaryKey() -> String? {
        return "seq"
    }
    
//    init(title: String = "", color: String = "#000000") {
//        self.title = title
//        self.color = color
//        super.init()
//    }
//
//    required init() {
//        fatalError("init() has not been implemented")
//    }
//
//    required init(realm: RLMRealm, schema: RLMObjectSchema) {
//        fatalError("init(realm:schema:) has not been implemented")
//    }
//
//    required init(value: Any, schema: RLMSchema) {
//        fatalError("init(value:schema:) has not been implemented")
//    }
    
    func toDictionary() -> [String: Any?] {
        var dic: [String: Any?] = [:]
        dic["seq"] = self.seq
        dic["id"] = self.id
        dic["category_title"] = self.title
        dic["category_color"] = self.color
        
        return dic
    }
}

extension Category: IdentifiableType {
  var identity: Int {
    return self.isInvalidated ? 0 : id
  }
}
