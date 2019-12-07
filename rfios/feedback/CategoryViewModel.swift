//
//  CategoryViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/12/07.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation
import RxSwift

protocol CategoryViewModelType: BaseViewModelType {
    // Output
    var categoryList: Observable<[Category]> { get }
}

class CategoryViewModel: BaseViewModel, CategoryViewModelType {
    
    let categoryList: Observable<[Category]>
    
    override init() {
        
        var tmp: [Category] = []
        tmp.append(Category(title:"기본", color: "#000000"))
        tmp.append(Category(title:"기본2", color: "#ffffff"))
        tmp.append(Category(title:"기본3", color: "#000000"))
        
        self.categoryList = Observable.of(tmp)
        
        super.init()
        
    }
}
