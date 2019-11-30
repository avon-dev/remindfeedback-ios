//
//  RegisterViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/21.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RegisterViewModelType {
    // Input
    var emailInput: BehaviorSubject<String> { get }
    var nicknameInput: BehaviorSubject<String> { get }
    var pwdInput: BehaviorSubject<String> { get }
    var chkPwdInput: BehaviorSubject<String> { get }
    
    // output
    var emailValid: Observable<Bool> { get }
    var pwdValid: Observable<Bool> { get }
    var chkPwdValid: Observable<Bool> { get }
    
    var registerValid: Observable<Bool> { get }
    
    // to Model
    func reqRegister() -> Observable<(Bool, String?)>
    
    
}

class RegisterViewModel: RegisterViewModelType {
    
    var disposeBag = DisposeBag()
    
    let emailInput: BehaviorSubject<String>
    let nicknameInput: BehaviorSubject<String>
    let pwdInput: BehaviorSubject<String>
    let chkPwdInput: BehaviorSubject<String>
    
    let emailValid: Observable<Bool>
    let pwdValid: Observable<Bool>
    let chkPwdValid: Observable<Bool>
    
    let registerValid: Observable<Bool>
        
    var params: [String:Any] = [:]
    
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
        
        // 회원가입 가능 여부 체크
        registerValid = Observable.combineLatest(emailValid, pwdValid, chkPwdValid, resultSelector: { $0 && $1 && $2 })
        
        Observable.combineLatest(emailInput, nicknameInput, pwdInput, resultSelector: {

            var params: [String:Any] = [:]
            params["email"] = $0
            params["nickname"] = $1
            params["password"] = $2
            return params

            })
            .subscribe(onNext: { [weak self] in
                self?.params = $0
            })
            .disposed(by: disposeBag)
        /**
        TODO
         회원가입버튼 누르면 릴레이 터트리고
         릴레이가 api 콜하고
         뷰컨에서 이를 서브스크라이브 해야한다
         */
        
    }
    
    func reqRegister() -> Observable<(Bool, String?)> {
        
        return APIHelper.sharedInstance.rxPushRequest(.register(self.params))
            .map {
                if $0.isSuccess {
                    return (true, nil)
                } else {
                    return (false , "회원가입 실패")
                }
            }
    }

}

