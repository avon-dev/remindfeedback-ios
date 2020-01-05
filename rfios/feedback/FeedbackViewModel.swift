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
    var titleInput: BehaviorSubject<String> { get }
    
    var selectedIndex: Int? { get }
}

class FeedbackViewModel: BaseViewModel, FeedbackViewModelType {
    
    let titleInput: BehaviorSubject<String>
    
    var selectedIndex: Int?
    
    override init() {
        self.titleInput = BehaviorSubject(value: "")
        super.init()
    }
    
    
}
