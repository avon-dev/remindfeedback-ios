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
    
    @IBOutlet weak var registerBtn: UIButton!
    
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
    }
}

// - MARK: Scene
extension LoginViewController {
    
}
