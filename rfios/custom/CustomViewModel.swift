//
//  CustomViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/02/02.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ViewModelType: BaseViewModelType {
    
}

class ViewModel: BaseViewModel, ViewModelType {
    
    override init() {
        super.init()
    }
    
}

