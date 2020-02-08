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

    /// 게시물 추가 버튼
    @IBOutlet weak var addCardBtn: UIButton!
    /// 게시물 리스트
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBinding()
    }
    
}

// - MARK: UI
extension BoardViewController {
    func setUI() {
        setNavUI()
    }
    
    func setNavUI() {
        // 네비게이션 바 색상 지정
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
}

// - MARK: Binding
extension BoardViewController {
    func setBinding() {
        
        // Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 { self?.viewModel.setScene(self ?? UIViewController()) }
            })
            .disposed(by: self.disposeBag)
        
        // VM to V
        // 네비게이션 바 타이틀 설정
        self.viewModel.navTitleOb
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: self.disposeBag)
            
        
        // V to VM
        self.addCardBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.onEditTextCard()
            })
            .disposed(by: self.disposeBag)
    }
}
