//
//  EditCategoryViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/12/07.
//  Copyright © 2019 avon. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import RxViewController
import UIKit

class EditCategoryViewController: UIViewController {
    
    var viewModel: CategoryViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: CategoryViewModelType = CategoryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = CategoryViewModel()
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    @IBOutlet weak var xBtn: UIBarButtonItem!
    @IBOutlet weak var completedBtn: UIBarButtonItem!
    @IBOutlet weak var titleTxtFld: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let statusBarView = UIApplication.statusBarView else { return }
//        UIApplication.statusBarBackgroundColor = .blue
        setBinding()
        
    }

}


extension EditCategoryViewController {
    
    func setBinding() {
        
        self.xBtn.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        self.completedBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.addCategory()
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        self.titleTxtFld.rx.text.orEmpty
            .bind(to: self.viewModel.titleInput)
            .disposed(by: self.disposeBag)
        
        Observable.of("#000000")
            .bind(to: self.viewModel.colorInput)
            .disposed(by: self.disposeBag)
        
        
    }
    
}
