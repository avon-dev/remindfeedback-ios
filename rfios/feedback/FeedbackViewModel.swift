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
    
    var selectedIndex: Int? { get }
    
    //
    func reqAddFeedback()
}

class FeedbackViewModel: BaseViewModel, FeedbackViewModelType {
    
    var feedback = Feedback()
    
    let categoryInput: BehaviorSubject<Int>
    let titleInput: BehaviorSubject<String>
    let dateInput: BehaviorSubject<Date>
    
    var selectedIndex: Int?
    
    override init() {
        self.categoryInput = BehaviorSubject(value: 0)
        self.titleInput = BehaviorSubject(value: "")
        self.dateInput = BehaviorSubject(value: Date())
        super.init()
        
        Observable.combineLatest(self.categoryInput, self.titleInput, dateInput, resultSelector: {
            let _feedback = Feedback()
            _feedback.category = $0
            _feedback.title = $1
            _feedback.date = $2
            return _feedback
        })
        .subscribe(onNext: { [weak self] in
            self?.feedback = $0
        })
        .disposed(by: self.disposeBag)
        
    }
    
}

extension FeedbackViewModel {
    func reqAddFeedback() {
       print("피드백 추가 요청")
        APIHelper.sharedInstance.rxPullResponse(.addFeedback(self.feedback.toDictionary()))
            .subscribe(onNext: {
                print($0.msg)
            })
            .disposed(by: self.disposeBag)
    }
}
