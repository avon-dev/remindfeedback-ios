//
//  LoginViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/21.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation
import RxSwift

protocol LoginViewModelType {
    // Input
    func onRegister()
    
    
    // Output
}

class LoginViewModel: LoginViewModelType { 
    
    init() {
        
    }
    
    func onRegister() {
        let registerViewModel = RegisterViewModel()
        SceneCoordinator.sharedInstance.showRegisterView(registerViewModel)
    }
    
    
}
