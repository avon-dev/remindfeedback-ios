//
//  RegisterViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/21.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation
import RxSwift

protocol RegisterViewModelType {
    // Input
    var emailInput: BehaviorSubject<String> { get }
    var nicknameInput: BehaviorSubject<String> { get }
    var pwdInput: BehaviorSubject<String> { get }
    var chkPwdInput: BehaviorSubject<String> { get }
    
    var emailValid: Observable<Bool> { get }
    var pwdValid: Observable<Bool> { get }
    var chkPwdValid: Observable<Bool> { get }
    
    var registerValid: Observable<Bool> { get }
    
}

class RegisterViewModel: RegisterViewModelType {
    
    let emailInput: BehaviorSubject<String>
    let nicknameInput: BehaviorSubject<String>
    let pwdInput: BehaviorSubject<String>
    let chkPwdInput: BehaviorSubject<String>
    
    let emailValid: Observable<Bool>
    let pwdValid: Observable<Bool>
    let chkPwdValid: Observable<Bool>
    
    let registerValid: Observable<Bool>
    
    init() {
        
        // 회원가입할 때 필요한 입력값을 받을 subject
        emailInput = BehaviorSubject(value: "")
        nicknameInput = BehaviorSubject(value: "")
        pwdInput = BehaviorSubject(value: "")
        chkPwdInput = BehaviorSubject(value: "")
        
        // 이메일 유효성 체크
        emailValid = emailInput.asObserver().map{ $0.validateEmail() }
        
        // 비밀번호 유효성 체크
        pwdValid = pwdInput.asObserver().map{ $0.validatePassword() }
        
        // 비밀번호 확인
        // 비밀번호가 일치하는지
        chkPwdValid = Observable.combineLatest(pwdInput, chkPwdInput, resultSelector: {
            pwd, chk in
            pwd == chk
        })
        
        registerValid = Observable.combineLatest(emailValid, pwdValid, chkPwdValid, resultSelector: { $0 && $1 && $2 })
        
    }
    
}

