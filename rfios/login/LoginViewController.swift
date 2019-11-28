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
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var appleBtn: UIButton!
    
    var cookie = ""
    var connectSid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        SceneCoordinator.sharedInstance.setCurrnentViewController(self)
    }
    
}

extension LoginViewController {
    func setBinding() {
        
        registerBtn.rx.tap
            .subscribe(
                onNext: {
                    self.viewModel.onRegister()
                }
            )
            .disposed(by: disposeBag)
        
        self.loginBtn.rx.tap
        .subscribe(
            onNext: {
                print("로그인 시도")
                
                let provider = MoyaProvider<BaseAPI>()
                
                var params: [String: Any] = [:]
                params["email"] = "z@www.com"
                params["password"] = "12345"
                
                provider.request(.login(params)) { result in
                    
//                    print("body", NSString(data: (result.value?.request?.httpBody)!, encoding:  String.Encoding.utf8.rawValue))
                    
                    switch result {
                    case let .success(moyaResponse):
                        let header = moyaResponse.response?.allHeaderFields
                        self.cookie = header?["Set-Cookie"] as! String
                        self.connectSid = String(self.cookie.split(separator: ";")[0].split(separator: "=")[1])
                        let data = moyaResponse.data
                        let statusCode = moyaResponse.statusCode
                        
                        if let headerFields = moyaResponse.response?.allHeaderFields as? [String: String], let URL = moyaResponse.request?.url
                        {
                             let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
                            HTTPCookieStorage.shared.setCookie(cookies.first!)
                             print("mCookie", cookies)
                        }
                        
                        do {
                          // 4
                          print(try moyaResponse.mapJSON())
                        } catch {
                          
                        }
                        
                        print("moyaResponse", moyaResponse)
                        print("header", header)
                        print("cookie", self.cookie)
                        print("connect.sid", self.connectSid)
                        print("data", data)
                        print("status",statusCode)

                    case let .failure(error):
                        print("error",error)
                    }
                }
                
                
                
            } // END : onNext
        )
        .disposed(by: disposeBag)
        
        
        appleBtn.rx.tap
        .subscribe(
            onNext: {
                let provider = MoyaProvider<BaseAPI>()
                                
//                HTTPCookieStorage.shared.setCookie(self.cookies!)
                
                provider.request(.me) { result in
                    print("내 정보")
//                    print("body", NSString(data: (result.value?.request?.httpBody)!, encoding:  String.Encoding.utf8.rawValue))
                    
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
                
            }// END : onNext
        )
        .disposed(by: disposeBag)
        
    }
}

// - MARK: Scene
extension LoginViewController {
    
}
