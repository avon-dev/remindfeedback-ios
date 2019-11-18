//
//  FriendListViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/18.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation
import RxSwift

protocol FriendListViewModelType {
    // output
    var friendList: Observable<[String]> { get }
}

class FriendListViewModel: FriendListViewModelType {
    
    let friendList: Observable<[String]>

    init() {
        self.friendList = Observable.of(["2월 최유연", "다크 유연", "시크 유연"])
    }
    
}
