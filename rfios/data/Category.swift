//
//  Category.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/12/07.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation

struct Category {
    var title = ""
    var color = "#000000"
    
    init(title: String = "", color: String = "#000000") {
        self.title = title
        self.color = color
    }
}
