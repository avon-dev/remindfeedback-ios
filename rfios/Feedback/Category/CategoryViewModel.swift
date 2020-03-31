//
//  CategoryViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/12/07.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON

protocol CategoryViewModelType: BaseViewModelType {
    // Output
    var categoryListOutput: BehaviorRelay<[Category]> { get }
    
    // Input
    var titleInput: BehaviorSubject<String> { get }
    var colorInput: BehaviorSubject<String> { get }
    
    // Scene
    func onAdd()
    func onModify(_ selectedIndex: Int)
    var selectedIndex: Int? { get set }
    
    // Control
    func getList()
    func add()
    func modify()
    func remove(_ index: Int)
    
    // For Feedback
    var isSelection: Bool { get }
    var feedbackViewModel: FeedbackViewModelType? { get }
    func choose()
}

class CategoryViewModel: BaseViewModel, CategoryViewModelType {
    
    let categoryListOutput: BehaviorRelay<[Category]>
    
    let titleInput: BehaviorSubject<String>
    let colorInput: BehaviorSubject<String>
    
    var categoryList: [Category] = []
    var category: Category = Category()
    
    var selectedIndex: Int?
    
    var isSelection = false
    var feedbackViewModel: FeedbackViewModelType?
    
    override init() {
        
        // MARK: List
        self.categoryListOutput = BehaviorRelay<[Category]>(value: categoryList)
        
        // MARK: Edit
        self.titleInput = BehaviorSubject(value: "")
        self.colorInput = BehaviorSubject(value: "")
        
        super.init()
        
        titleInput
            .subscribe(onNext: { [weak self] in
                self?.category.title = $0
            })
            .disposed(by: disposeBag)
        
        colorInput
            .subscribe(onNext: { [weak self] in
                self?.category.color = $0
            })
            .disposed(by: disposeBag)
    }
    
    
}

// MARK: Scene
extension CategoryViewModel {
    
    func onAdd() {
        self.selectedIndex = nil
        SceneCoordinator.sharedInstance.push(scene: .editCategoryView(self))
    }
    
    func onModify(_ selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        self.category = self.categoryList[selectedIndex]
        SceneCoordinator.sharedInstance.push(scene: .editCategoryView(self))
    }
    
    private func bindAlert(title: String, text: String) {
        SceneCoordinator.sharedInstance
            .getCurrentViewController()?
            .alert(title: title, text: text)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func finished() {
        SceneCoordinator.sharedInstance.hide()
        SceneCoordinator.sharedInstance.pop()
    }
}

// MARK: Control
extension CategoryViewModel {
    
    func getList() {
        requestList()
    }
    
    func add() {
        requestAddition()
    }
    
    func modify() {
        self.requestModification()
        if let index = selectedIndex {
            categoryList[index] = category
            categoryListOutput.accept(categoryList)
        }
    }
    
    func remove(_ index: Int) {
        self.category = self.categoryList[index]
        requestRemoval()
        self.categoryList.remove(at: index)
        self.categoryListOutput.accept(self.categoryList)
    }
    
    func choose() {
        self.category = self.categoryList[selectedIndex ?? 0]
        self.feedbackViewModel?.categoryOutput.accept(self.category)
        self.feedbackViewModel?.categoryInput.onNext(self.category) 
    }
    
}

// MARK: Network
extension CategoryViewModel {
    
    /// 카테고리 리스트 불러오기
    private func requestList() {
        SceneCoordinator.sharedInstance.show()
        APIHelper.sharedInstance.rxPullResponse(.getCategories)
            .subscribe(onNext: { [weak self] in
                
                self?.categoryList.removeAll()
                
                guard let dataList = $0.dataDic else { return }
                
                dataList.forEach { [weak self] in
                    let category = Category($0)
                    self?.categoryList.append(category)
                }
                
                self?.categoryListOutput.accept(self?.categoryList ?? [])
                }, onDisposed: {
                    SceneCoordinator.sharedInstance.hide()
            })
            .disposed(by: disposeBag)
    }
    
    /// 카테고리 추가 요청
    private func requestAddition() {
        
        guard !category.title.isEmpty else { return }
        
        SceneCoordinator.sharedInstance.show()
        APIHelper.sharedInstance.rxPullResponse(.addCategory(category.toDictionary()))
            .subscribe(onNext: { [weak self] in
                guard $0.isSuccess else {
                    self?.bindAlert(title: "안내", text: $0.msg ?? "알 수 없는 오류가 발생했습니다.")
                    return
                }
                self?.finished()
            }, onError: { [weak self] _ in
                self?.bindAlert(title: "안내", text: "주제 추가가 실패했습니다.")
            })
            .disposed(by: disposeBag)
    }
    
    /// 카테고리 수정 요청
    private func requestModification() {
        
        SceneCoordinator.sharedInstance.show()
        APIHelper.sharedInstance.rxPullResponse(.modCategory(category.toDictionary(), id: String(category.id)))
            .subscribe(onNext: { [weak self] in
                guard $0.isSuccess else {
                    self?.bindAlert(title: "안내", text: $0.msg ?? "알 수 없는 오류가 발생했습니다.")
                    return
                }
                self?.finished()
            }, onError: { [weak self] _ in
                self?.bindAlert(title: "안내", text: "주제 수정이 실패했습니다.")
            })
            .disposed(by: disposeBag)
    }
    
    /// 카테고리 추가 요청
    private func requestRemoval() {
        
        SceneCoordinator.sharedInstance.show()
        APIHelper.sharedInstance.rxPullResponse(.delCategory(String(category.id)))
            .subscribe(onNext: { [weak self] in
                guard $0.isSuccess else {
                    self?.bindAlert(title: "안내", text: $0.msg ?? "알 수 없는 오류가 발생했습니다.")
                    return
                }
                SceneCoordinator.sharedInstance.hide()
            }, onError: { [weak self] _ in
                self?.bindAlert(title: "안내", text: "주제 삭제가 실패했습니다.")
            })
            .disposed(by: disposeBag)
    }
    
}


