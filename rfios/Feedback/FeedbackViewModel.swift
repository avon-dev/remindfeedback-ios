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
    var categoryInput: BehaviorSubject<Category> { get }
    var titleInput: BehaviorSubject<String> { get }
    var dateInput: BehaviorSubject<Date> { get }
    
    var feedback: Feedback { get }
    var categoryOutput: BehaviorRelay<Category> { get }
    var feedbackOutput: BehaviorRelay<Feedback> { get }
    
    //
    func setFeedback()
    
    // Scene
    func onCategory()
    
    //
    func requestAddition()
}

class FeedbackViewModel: BaseViewModel, FeedbackViewModelType {
    
    var feedback = Feedback()
    
    let categoryInput: BehaviorSubject<Category>
    let titleInput: BehaviorSubject<String>
    let dateInput: BehaviorSubject<Date>
    
    var categoryOutput: BehaviorRelay<Category>
    var feedbackOutput: BehaviorRelay<Feedback>
    
    
    var mainViewModel: MainViewModelType?
    
    override init() {
        self.categoryInput = BehaviorSubject(value: Category())
        self.titleInput = BehaviorSubject(value: "")
        self.dateInput = BehaviorSubject(value: Date())
        
        self.categoryOutput = BehaviorRelay<Category>(value: Category())
        self.feedbackOutput = BehaviorRelay<Feedback>(value: feedback)
        
        super.init()
        
        Observable.combineLatest(self.categoryInput, self.titleInput, self.dateInput, resultSelector: {
            var _feedback = self.feedback
            _feedback.category = $0
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

// MARK: Scene
extension FeedbackViewModel {
    
    func setFeedback() {
        feedbackOutput.accept(feedback)
    }
    
    func onCategory() {
        let categoryViewModel = CategoryViewModel()
        categoryViewModel.isSelection = true
        categoryViewModel.feedbackViewModel = self
        SceneCoordinator.sharedInstance.push(scene: .categoryView(categoryViewModel))
    }
    
    private func bindAlert(title: String, text: String) {
        SceneCoordinator.sharedInstance
            .getCurrentViewController()?
            .alert(title: title, text: text)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

// MARK: Network
extension FeedbackViewModel {
    func requestAddition() {
        
        SceneCoordinator.sharedInstance.show()
        
        APIHelper.sharedInstance
            .rxPullResponse(.addFeedback(feedback.toDictionary()))
            .subscribe(onNext: { [weak self] in
                guard $0.isSuccess, let data = $0.data else {
                    self?.bindAlert(title: "안내"
                        , text: $0.msg ?? "알 수 없는 오류가 발생했습니다.")
                    return
                }
                
                self?.feedback.id = data["id"] as? Int ?? -1
                self?.mainViewModel?.addFeedback(self?.feedback)
                SceneCoordinator.sharedInstance.pop()
                }, onDisposed: {
                    SceneCoordinator.sharedInstance.hide()
            })
            .disposed(by: self.disposeBag)
    }
}
