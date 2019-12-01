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
    var emailInput: BehaviorSubject<String> { get }
    var pwdInput: BehaviorSubject<String> { get }
    
    // Output
    
    // Scene
    func onRegister()
    
    // ViewModel to NetworkService
    func reqLogin() -> Observable<(Bool, String?, String?)>
    
}

class LoginViewModel: LoginViewModelType {
    
    var disposeBag = DisposeBag()
    
    // Input
    let emailInput: BehaviorSubject<String>
    let pwdInput: BehaviorSubject<String>
    
    var params: [String: Any?] = [:]
    
    init() {
        // 로그인할 때 필요한 입력값을 받을 subject
        emailInput = BehaviorSubject(value: "")
        pwdInput = BehaviorSubject(value: "")
        
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
            .disposed(by: disposeBag)
    }
    
    
    
    
}

// -MARK: Scene
extension LoginViewModel {
    
    // 회원가입 뷰컨으로 이동
    func onRegister() {
        NWLog.cLog()
        let registerViewModel = RegisterViewModel()
        SceneCoordinator.sharedInstance.showRegisterView(registerViewModel)
    }
    
}

//
extension LoginViewModel {
    func reqLogin() -> Observable<(Bool, String?, String?)> {
        print(self.params)
        return APIHelper.sharedInstance.rxPostRequest(.login(self.params))
            .map { ($0.isSuccess, $0.msg, $0.data) }
    }
}
