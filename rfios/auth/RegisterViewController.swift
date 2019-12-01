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

// 프로퍼티 초기화 및 생명주기
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        self.disposeBag = DisposeBag()
    }
    
    @IBAction func dismissThisView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

// UI 및 바인딩 세팅
extension RegisterViewController {
    
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
        
        // 회원가입 요청
        self.reqRegisterBtn.rx.tap
            .flatMap{ self.viewModel.reqRegister() }
            .subscribe(
                onNext: {
                    print("회원가입 시도", $0)
                    if $0.0 {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        // - TODO: 회원가입 실패 시, Alert 실행
                    }
                    
                }
            )
            .disposed(by: disposeBag)
        
        
        // - MARK: VIEWMODEL to VIEW
        
        // 가입가능 여부 체크
        viewModel.registerValid
//            .subscribe(
//                onNext: {
//                print("가입가능?", $0)
//                    self.reqRegisterBtn.isEnabled = $0
//                }
//            )
            .bind(to: self.reqRegisterBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        
        
    }
    
}
