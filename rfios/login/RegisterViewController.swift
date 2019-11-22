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
        setBinding()
    }
    
    @IBAction func dismissThisView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUI() {
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
            .subscribe(onNext: {
                print("가입가능", $0)
                self.reqRegisterBtn.isEnabled = $0
            } )
            .disposed(by: disposeBag)
        
    }
    
}
