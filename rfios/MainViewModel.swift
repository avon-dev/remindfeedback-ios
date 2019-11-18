//
//  MainViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/09.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation
import RxSwift

protocol MainViewModelType {
    // output
    var feedbackList: Observable<[String]> { get }
}

class MainViewModel: MainViewModelType {
    
    let feedbackList: Observable<[String]>
    
    init() {
        self.feedbackList = Observable.of(["ㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹ", "222", "333"])
    }
}
