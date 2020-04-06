//
//  CustomViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/02/02.
//  Copyright © 2020 avon. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import RxViewController
import UIKit

class ViewController: UIViewController {
    
    var viewModel: ViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: ViewModelType = ViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = ViewModel()
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBinding()
    }
    
}

// MARK: UI
extension ViewController {
    func setUI() {
        
    }
}

// MARK: Binding
extension ViewController {
    func setBinding() {
        
    }
}
