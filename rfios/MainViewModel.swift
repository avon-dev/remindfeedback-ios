//
//  MainViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/09.
//  Copyright © 2019 avon. All rights reserved.
//

import Action
import Foundation
import RxDataSources
import RxSwift

protocol MainViewModelType: BaseViewModelType {
    // Output
    var feedbackList: Observable<[Feedback]> { get }
    
    // Scene
    func onCategory()
}

typealias FeedbackSection = AnimatableSectionModel<String, Feedback>

class MainViewModel: BaseViewModel, MainViewModelType {
    
    let feedbackList: Observable<[Feedback]>
    
    override init() {
//        self.feedbackList = Observable.of(["ㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹ", "222", "333"])
        self.feedbackList = Observable.of([Feedback()])
        super.init()
    }
    
    
}

extension MainViewModel {
    func onCategory() {
        let categoryViewModel = CategoryViewModel()
        SceneCoordinator.sharedInstance.showCategoryView(categoryViewModel)
    }
}
