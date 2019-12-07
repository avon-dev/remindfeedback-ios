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

import Moya
import RealmSwift
import SwiftyJSON

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
    @IBOutlet weak var appleBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinding()
    }
    

    
}

extension LoginViewController {

    func setBinding() {
        
        // Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 { self?.viewModel.setScene(self ?? UIViewController()) }
            })
            .disposed(by: self.disposeBag)
        
        // Input
        self.emailTxtField.rx.text.orEmpty
            .bind(to: self.viewModel.emailInput)
            .disposed(by: self.disposeBag)
        
        self.pwdTxtField.rx.text.orEmpty
            .bind(to: self.viewModel.pwdInput)
            .disposed(by: self.disposeBag)
        
        self.loginBtn.rx.tap
            .flatMap { self.viewModel.reqLogin() }
            .subscribe(onNext: {
                print("로그인", $0.0, $0.2 ?? "")
                if $0.0 { self.dismiss(animated: true, completion: nil) }
            })
            .disposed(by: self.disposeBag)
        
        self.appleBtn.rx.tap
            .flatMap { self.viewModel.reqMe() }
            .subscribe(onNext: {
                print("ME", $0.0, $0.2 ?? "")
            })
            .disposed(by: self.disposeBag)
        
        self.registerBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                print("on회원가입")
                self?.viewModel.onRegister()
            })
            .disposed(by: self.disposeBag)
        
        

    } // END : setBinding()

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

