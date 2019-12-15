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

protocol CategoryViewModelType: BaseViewModelType {
    // Output
    var categoryListOb: BehaviorRelay<[Category]> { get }
    
    // Input
    var titleInput: BehaviorSubject<String> { get }
    var colorInput: BehaviorSubject<String> { get }
    
    func onAdd()
    
    func addCategory()
}

class CategoryViewModel: BaseViewModel, CategoryViewModelType {
    
    let categoryListOb: BehaviorRelay<[Category]>
    
    let titleInput: BehaviorSubject<String>
    let colorInput: BehaviorSubject<String>
    
    var categoryList: [Category] = []
    var category: Category = Category()
    
    override init() {
        
        // -MARK: List
        categoryList.append(Category(title:"기본", color: "#000000"))
        categoryList.append(Category(title:"기본2", color: "#ffffff"))
        categoryList.append(Category(title:"기본3", color: "#000000"))
        
        self.categoryListOb = BehaviorRelay<[Category]>(value: categoryList)
        
        // -MARK: Edit
        self.titleInput = BehaviorSubject(value: "")
        self.colorInput = BehaviorSubject(value: "")
        
        super.init()
        
        Observable.combineLatest(titleInput, colorInput, resultSelector: {
                return Category(title: $0, color: $1)
            })
            .subscribe(onNext: { [weak self] in
                self?.category = $0
            })
            .disposed(by: self.disposeBag)
    }
}

// -MARK: Scene
extension CategoryViewModel {
    func onAdd() {
        SceneCoordinator.sharedInstance.showEditCategoryView(self)
    }
}

// -MARK: Add
extension CategoryViewModel {
    
    func addCategory() {
        print("주제 추가")
        self.categoryList.append(self.category)
        self.categoryListOb.accept(self.categoryList)
    }
    
}

