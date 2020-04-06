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
    var feedbackOutput: BehaviorRelay<Feedback> { get }
    
    var colorOutput: BehaviorRelay<UIColor> { get }
    var categoryTitleOutput: BehaviorRelay<String> { get }
    var feedbackTitleOutput: BehaviorRelay<String> { get }
    var dateOutput: BehaviorRelay<Date> { get }
    
    // Input
    var categoryInput: BehaviorSubject<Category> { get }
    var titleInput: BehaviorSubject<String> { get }
    var dateInput: BehaviorSubject<Date> { get }
    
    var feedback: Feedback { get }
    
    // Scene
    func onCategory()
    func onAdviser()
    
    // CRUD
    func doneEdition()
}

class FeedbackViewModel: BaseViewModel, FeedbackViewModelType {
    
    var feedbackOutput: BehaviorRelay<Feedback>
    
    let colorOutput: BehaviorRelay<UIColor>
    let categoryTitleOutput: BehaviorRelay<String>
    let feedbackTitleOutput: BehaviorRelay<String>
    let dateOutput: BehaviorRelay<Date>
    
    var feedback = Feedback() {
        didSet {
            let color = UIUtil.hexStringToUIColor(feedback.category.color)
            colorOutput.accept(color)
            categoryTitleOutput.accept(feedback.category.title)
            feedbackTitleOutput.accept(feedback.title)
            dateOutput.accept(feedback.date)
        }
    }
    
    let categoryInput: BehaviorSubject<Category>
    let titleInput: BehaviorSubject<String>
    let dateInput: BehaviorSubject<Date>
    
    var mainViewModel: MainViewModelType?
    
    override init() {
        
        self.feedbackOutput = BehaviorRelay<Feedback>(value: feedback)
        
        let color = UIUtil.hexStringToUIColor(feedback.category.color)
        colorOutput = BehaviorRelay<UIColor>(value: color)
        categoryTitleOutput = BehaviorRelay<String>(value: feedback.category.title)
        feedbackTitleOutput = BehaviorRelay<String>(value: feedback.title)
        dateOutput = BehaviorRelay<Date>(value: feedback.date)
        
        self.categoryInput = BehaviorSubject(value: Category())
        self.titleInput = BehaviorSubject(value: "")
        self.dateInput = BehaviorSubject(value: Date())
        
        super.init()
        
        categoryInput.subscribe(onNext: { [weak self] in
            self?.feedback.category = $0
        }).disposed(by: disposeBag)
        
        titleInput.filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] in
                self?.feedback.title = $0
            }).disposed(by: disposeBag)
        
        dateInput.subscribe(onNext: { [weak self] in
            self?.feedback.date = $0
        }).disposed(by: disposeBag)
        
    }
    
}

// MARK: Scene
extension FeedbackViewModel {
    
    func onCategory() {
        let categoryViewModel = CategoryViewModel()
        categoryViewModel.isSelection = true
        categoryViewModel.feedbackViewModel = self
        SceneCoordinator.sharedInstance.push(scene: .categoryView(categoryViewModel))
    }
    
    func onAdviser() {
        let adviserModel = AdviserListViewModel()
        SceneCoordinator.sharedInstance.push(scene: .adviserListView(adviserModel))
    }
    
    private func bindAlert(title: String, text: String) {
        SceneCoordinator.sharedInstance
            .getCurrentViewController()?
            .alert(title: title, text: text)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

// MARK: CRUD
extension FeedbackViewModel {
    func doneEdition() {
        feedback.id == -1 ? requestAddition() : requestModification()
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
            }).disposed(by: disposeBag)
    }
    
    func requestModification() {
        SceneCoordinator.sharedInstance.show()
        
        APIHelper.sharedInstance
            .rxPullResponse(.modFeedback(feedback.toDictionary(), id: String(feedback.id)))
            .subscribe(onNext: { [weak self] in
                guard $0.isSuccess else {
                    self?.bindAlert(title: "안내"
                        , text: $0.msg ?? "알 수 없는 오류가 발생했습니다.")
                    return
                }
                
                self?.mainViewModel?.modifyFeedback(self?.feedback) 
                SceneCoordinator.sharedInstance.pop()
                }, onDisposed: {
                    SceneCoordinator.sharedInstance.hide()
            }).disposed(by: disposeBag)
    }
}
