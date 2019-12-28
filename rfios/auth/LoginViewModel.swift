//
//  LoginViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/21.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation
import RxSwift

protocol LoginViewModelType: BaseViewModelType {
    // Input
    var emailInput: BehaviorSubject<String> { get }
    var pwdInput: BehaviorSubject<String> { get }
    
    // Output
    
    // Scene
//    func setScene(_ viewController: UIViewController)
    func onRegister()
    
    // ViewModel to NetworkService
    func reqLogin() -> Observable<(Bool, String?, String?)>
    func reqMe() -> Observable<(Bool, String?, String?)>
    
}

class LoginViewModel: BaseViewModel, LoginViewModelType {
    
    // Input
    let emailInput: BehaviorSubject<String>
    let pwdInput: BehaviorSubject<String>
    
    var params: [String: Any?] = [:]
    
    override init() {
        // 로그인할 때 필요한 입력값을 받을 subject
        emailInput = BehaviorSubject(value: "")
        pwdInput = BehaviorSubject(value: "")
        
        super.init()
        
        // 로그인 요청할 때 필요한 파라미터 값을 딕셔너리형태로 저장
        Observable.combineLatest(emailInput, pwdInput, resultSelector: {

            var params: [String:Any] = [:]
            params["email"] = $0
            params["password"] = $1
            return params

            })
            .subscribe(onNext: { [weak self] in
                self?.params = $0
            })
            .disposed(by: self.disposeBag)
        
    }
    
    
}

// -MARK: Scene
extension LoginViewModel {
    
    // 회원가입 뷰컨으로 이동
    func onRegister() {
        let registerViewModel = RegisterViewModel()
        SceneCoordinator.sharedInstance.showRegisterView(registerViewModel)
    }
    
}

// - MARK: Network
extension LoginViewModel {
    
    //
    func reqLogin() -> Observable<(Bool, String?, String?)> {
        print("로그인 요청", self.params)
        return APIHelper.sharedInstance.rxSetSession(.login(self.params))
            .map { ($0.isSuccess, $0.msg, $0.data) }
    }
    
    //
    func reqMe() -> Observable<(Bool, String?, String?)> {
        return APIHelper.sharedInstance.rxPushRequest(.me)
        .map { ($0.isSuccess, $0.msg, $0.data) }
    }
    
}
