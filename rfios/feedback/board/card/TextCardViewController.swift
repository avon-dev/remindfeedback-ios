//
//  TextCardViewController.swift
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

class TextCardViewController: UIViewController {

    var viewModel: CardViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: CardViewModelType = CardViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = CardViewModel() 
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    @IBOutlet weak var titleDateLabel: UILabel!
    @IBOutlet weak var contentTxtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBinding()
    }

}

// - MARK: UI
extension TextCardViewController {
    func setUI() {
        setNavUI()
    }
    
    func setNavUI() {
        // 네비게이션 바 색상 지정
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
}

// - MARK: Binding
extension TextCardViewController {
    func setBinding() {
        // Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 { self?.viewModel.setScene(self ?? UIViewController()) }
            })
            .disposed(by: self.disposeBag)
        
        // VM to V
        self.viewModel.titleDateOb
            .bind(to: self.titleDateLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.contentOb
            .bind(to: self.contentTxtView.rx.text)
            .disposed(by: self.disposeBag)
        
    }
}
