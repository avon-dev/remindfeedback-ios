//
//  Card.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/02/04.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation

struct Card {
    
    var id = -1
    var title = ""
    var date = Date()
    var content = ""
    var feedbackID = -1
    var category = -1
    var fileList: [String] = []
    
    init() {
        
    }
    
    init(_ dic: [String:Any]) {
        
        id = dic["id"] as? Int ?? -1
        category = dic["board_category"] as? Int ?? -1
        title = dic["board_title"] as? String ?? ""
        content = dic["board_content"] as? String ?? ""
        feedbackID = dic["fk_feedbackId"] as? Int ?? -1
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        let dateStr: String = dic["createdAt"] as? String ?? ""
        date = dateFormatter.date(from: dateStr) ?? Date()
        
        guard dic["board_file1"] != nil else { return }
        
        (1...3).forEach {
            if let filePath = dic["board_file\($0)"] as? String {
                fileList.append(filePath)
            }
        }
        
        /**
        TODO
        board_file1=[string] 1번째 사진파일, 영상, 녹음파일
        board_file2=[string] (사진게시물) 2번째 사진파일
        board_file3=[string] (사진게시물) 3번째 사진파일
        confirm=[boolean] 게시물 확인 여부
        */
    }
    
    func toDictionary() -> [String: Any?] {
        var dic: [String: Any?] = [:]
        dic["id"] = self.id
        dic["board_title"] = self.title
        dic["board_content"] = self.content
        dic["feedback_id"] = self.feedbackID
        
        return dic
    }
}
