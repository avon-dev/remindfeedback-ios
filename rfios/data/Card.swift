//
//  Card.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/02/04.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation

class Card {
    
    var seq = -1
    var id = -1
    var title = ""
    var date = Date()
    var content = ""
    var feedbackID = -1
    var category = -1
    
    
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
