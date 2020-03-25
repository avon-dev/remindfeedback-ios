//
//  FeedbackViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/01/04.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol FeedbackViewModelType: BaseViewModelType {
    // Output
    
    // Input
    var categoryInput: BehaviorSubject<Int> { get }
    var titleInput: BehaviorSubject<String> { get }
    var dateInput: BehaviorSubject<Date> { get }
    
    var feedback: Feedback { get }
    var categoryOb: BehaviorRelay<Category> { get }
    var feedbackOb: BehaviorRelay<Feedback> { get }
    
    //
    func setFeedback()
    func onCategory()
    
    //
    func reqAddFeedback()
}

class FeedbackViewModel: BaseViewModel, FeedbackViewModelType {
    
    var feedback = Feedback()
    
    let categoryInput: BehaviorSubject<Int>
    let titleInput: BehaviorSubject<String>
    let dateInput: BehaviorSubject<Date>
    
    var categoryOb: BehaviorRelay<Category>
    var feedbackOb: BehaviorRelay<Feedback>
    
    override init() {
        self.categoryInput = BehaviorSubject(value: 0)
        self.titleInput = BehaviorSubject(value: "")
        self.dateInput = BehaviorSubject(value: Date())
        
        self.categoryOb = BehaviorRelay<Category>(value: Category())
        self.feedbackOb = BehaviorRelay<Feedback>(value: self.feedback)
        
        super.init()
        
        Observable.combineLatest(self.categoryInput, self.titleInput, self.dateInput, resultSelector: {
            var _feedback = self.feedback
            var _category = Category()
            _category.id = $0 
            _feedback.category = _category
            _feedback.title = $1
            _feedback.date = $2
            return _feedback
        })
        .filter{ $0.title != "" }
        .subscribe(onNext: { [weak self] in
            self?.feedback = $0
        })
        .disposed(by: self.disposeBag)
        
    }
    
}

extension FeedbackViewModel {
    
    func setFeedback() {
        self.feedbackOb.accept(self.feedback)
    }
    
    func onCategory() {
        let categoryViewModel = CategoryViewModel()
        categoryViewModel.isSelection = true
        categoryViewModel.feedbackViewModel = self
        SceneCoordinator.sharedInstance.push(scene: .categoryView(categoryViewModel))
    }
}

extension FeedbackViewModel {
    func reqAddFeedback() {
        APIHelper.sharedInstance.rxPullResponse(.addFeedback(self.feedback.toDictionary()))
            .subscribe(onNext: {
                NWLog.sLog(contentName: "피드백 추가 응답 결과", contents: $0.msg)
            })
            .disposed(by: self.disposeBag)
    }
}
