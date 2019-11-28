//
//  ViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/09.
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

class RegisterViewController: UIViewController {
    
    var viewModel: RegisterViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: RegisterViewModelType = RegisterViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = RegisterViewModel() 
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var chkPwdTextField: UITextField!
    
    @IBOutlet weak var reqRegisterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBinding()
    }
    
    @IBAction func dismissThisView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUI() {
        // VIEW가 처음에 화면에 보여질 때는 회원가입이 불가능하게끔 만들어 놓음
        // 그래서 버튼을 비활성화 처리함
        self.reqRegisterBtn.isEnabled = false
    }
    
    func setBinding() {
        
        // - MARK: VIEW to VIEWMODEL
        
        self.emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailInput)
            .disposed(by: disposeBag)
        
        self.nicknameTextField.rx.text.orEmpty
            .bind(to: viewModel.nicknameInput)
            .disposed(by: disposeBag)
        
        self.pwdTextField.rx.text.orEmpty
            .bind(to: viewModel.pwdInput)
            .disposed(by: disposeBag)
        
        self.chkPwdTextField.rx.text.orEmpty
            .bind(to: viewModel.chkPwdInput)
            .disposed(by: disposeBag)
        
        // - MARK: VIEWMODEL to VIEW
        
//        viewModel.emailInput.asObserver()
//            .subscribe(onNext: { print("이메일", $0) } )
//            .disposed(by: disposeBag)
        
        //
        viewModel.registerValid
            .subscribe(
                onNext: {
                print("가입가능", $0)
                    self.reqRegisterBtn.isEnabled = $0
                }
            )
            .disposed(by: disposeBag)
        
        
        self.reqRegisterBtn.rx.tap
            .subscribe(
                onNext: {
                    print("회원가입 시도")
                    
                    let provider = MoyaProvider<BaseAPI>()
                    
                    var params: [String: Any] = [:]
                    params["email"] = "z@www.com"
                    params["nickname"] = "www"
                    params["password"] = "12345"
                    
                    provider.request(.register(params)) { result in
                        
                        print("body", NSString(data: (result.value?.request?.httpBody)!, encoding:  String.Encoding.utf8.rawValue))
                        
                        switch result {
                        case let .success(moyaResponse):
                            let header = moyaResponse.response?.allHeaderFields
                            let data = moyaResponse.data
                            let statusCode = moyaResponse.statusCode
                            
                            do {
                              // 4
                              print(try moyaResponse.mapJSON())
                            } catch {
                              
                            }
                            
                            print("moyaResponse", moyaResponse)
                            print("header", header)
                            print("data", data)
                            print("status",statusCode)

                        case let .failure(error):
                            print("error",error)
                        }
                    }
                    
                    
                    
                } // END : onNext
            )
            .disposed(by: disposeBag)
        
    }
    
}
