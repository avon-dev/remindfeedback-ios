//
//  MainViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/08.
//  Copyright © 2019 avon. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import RxViewController
import UIKit

class LoginViewController: UIViewController {
    
    var viewModel: LoginViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: LoginViewModelType = LoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = LoginViewModel()
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinding()
    }
    
}

// MARK: Binding
extension LoginViewController {

    func setBinding() {
        
        // MARK: Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 { self?.viewModel.setScene(self ?? UIViewController()) }
            })
            .disposed(by: self.disposeBag)
        
        // MARK: Input
        emailTxtField.rx.text.orEmpty
            .bind(to: self.viewModel.emailInput)
            .disposed(by: disposeBag)
        
        pwdTxtField.rx.text.orEmpty
            .bind(to: self.viewModel.pwdInput)
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap
            .flatMap { self.viewModel.requestLogin() }
            .subscribe(onNext: {
                if $0.0 {
                    self.dismiss(animated: true, completion: nil)
                    UserDefaultsHelper.sharedInstantce.setUUID($0.2?["user_uid"] as? String ?? "")
                }
            })
            .disposed(by: self.disposeBag)
        
        registerBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.onRegister()
            })
            .disposed(by: disposeBag)
        
        keyboardHeight()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.view.frame.origin.y = -$0/2
            })
            .disposed(by: disposeBag)
    }

}


//
//extension LoginViewController {
//    func setBinding() {
//
//        registerBtn.rx.tap
//            .subscribe(
//                onNext: {
//                    self.viewModel.onRegister()
//                }
//            )
//            .disposed(by: disposeBag)
//
//
//
//
//        appleBtn.rx.tap
//        .subscribe(
//            onNext: {
//                let provider = MoyaProvider<BaseAPI>()
//
////                HTTPCookieStorage.shared.setCookie(self.cookies!)
//
//                provider.request(.me) { result in
//                    print("내 정보")
////                    print("body", NSString(data: (result.value?.request?.httpBody)!, encoding:  String.Encoding.utf8.rawValue))
//
//                    switch result {
//                    case let .success(moyaResponse):
//                        let header = moyaResponse.response?.allHeaderFields
//                        let data = moyaResponse.data
//                        let statusCode = moyaResponse.statusCode
//
//                        do {
//                          // 4
//                          print(try moyaResponse.mapJSON())
//                        } catch {
//
//                        }
//
//                        print("moyaResponse", moyaResponse)
//                        print("header", header)
//                        print("data", data)
//                        print("status",statusCode)
//
//                    case let .failure(error):
//                        print("error",error)
//                    }
//                }
//
//            }// END : onNext
//        )
//        .disposed(by: disposeBag)
//
//    }
//}
//

