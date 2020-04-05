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
    @IBOutlet weak var chkEmailBtn: UIButton!
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
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    @IBAction func dismissThisView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

// MARK: UI
extension RegisterViewController {
    func setUI() {
        func setUI() {
            // VIEW가 처음에 화면에 보여질 때는 회원가입이 불가능하게끔 만들어 놓음
            // 그래서 버튼을 비활성화 처리함
            self.reqRegisterBtn.isEnabled = false
        }
    }
}

// MARK: Binding
extension RegisterViewController {
    func setBinding() {
        
        // MARK: Input
    
        self.emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailInput)
            .disposed(by: disposeBag)
        
        self.chkEmailBtn.rx.tap
//            .concatMap { self.viewModel.emailValid }
//            .filter { $0 == true }
            .concatMap{ _ in self.viewModel.requestCheckEmail() }
            .subscribe(onNext: { [weak self] in
                if $0 == "" {
                    self?.bindAlert(title: "이메일 확인", content: "사용 불가능한 이메일입니다.")
                } else {
                    self?.bindAlert(title: "이메일 확인", content: "사용가능한 이메일 입니다.")
                }
            })
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
        
        /// 회원가입 요청
        self.reqRegisterBtn.rx.tap
            .flatMap{ self.viewModel.requestRegister() }
            .subscribe(
                onNext: { [weak self] in
                    if $0.0 {
                        self?.dismiss(animated: true, completion: nil)
                    } else {
                        self?.bindAlert(title: "회원가입 실패", content: "회원 가입을 다시 시도해 주세요.")
                    }
                }
            )
            .disposed(by: disposeBag)
        
        // Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 { self?.viewModel.setScene(self ?? UIViewController()) }
            })
            .disposed(by: self.disposeBag)
        
        
        // MARK: Output
        
        // 가입가능 여부 체크
        viewModel.registerValid
            .bind(to: self.reqRegisterBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
    }
    
    func bindAlert(title: String, content: String) {
        alert(title: title, text: content)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}
