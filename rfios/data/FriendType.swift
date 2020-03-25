//
//  FriendType.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/03/23.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation

enum FriendType: Int {
    case abNone = -1
    case bDenial = 0
    case aRequest = 1
    case bRequest = 6 // 서버에는 없는 타입
    case abfriend = 2
    case aBlock = 3
    case bBlock = 4
    case block = 5
}
