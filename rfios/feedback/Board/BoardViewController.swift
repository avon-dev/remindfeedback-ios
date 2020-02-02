//
//  BoardViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/01/21.
//  Copyright © 2020 avon. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import RxViewController
import UIKit

class BoardViewController: UIViewController {
    
    var viewModel: BoardViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: BoardViewModelType = BoardViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = BoardViewModel()
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

extension BoardViewController {
    func setUI() {
        
    }
}

extension BoardViewController {
    func setBinding() {
        
    }
}
