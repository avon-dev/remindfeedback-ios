//
//  MainViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/09.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation
import RxSwift

protocol MainViewModelType: BaseViewModelType {
    // Output
    var feedbackList: Observable<[String]> { get }
    
    // Scene
    func onCategory()
}

class MainViewModel: BaseViewModel, MainViewModelType {
    
    let feedbackList: Observable<[String]>
    
    override init() {
        self.feedbackList = Observable.of(["ㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹ", "222", "333"])
        super.init()
    }
    
    
}

extension MainViewModel {
    func onCategory() {
        let categoryViewModel = CategoryViewModel()
        SceneCoordinator.sharedInstance.showCategoryView(categoryViewModel)
    }
}
