//
//  CategoryViewController.swift
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

class CategoryViewController: UIViewController {
    
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
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBinding()
    }
   
}

extension CategoryViewController {
    func setUI() {
        // 네비게이션 바 타이틀 설정
        self.navigationItem.title = "피드백 주제" // -TODO: 추후 해당 리터럴값을 뷰 모델에서 가져올 수 있도록 수정 필요
        
        // 네비게이션 바 색상 지정
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // 네비게이션 바 우측버튼
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: nil)
    }
}

extension CategoryViewController {
    
    func setBinding() {
        
        // Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 { self?.viewModel.setScene(self ?? UIViewController()) }
            })
            .disposed(by: self.disposeBag)
        
        // Output
        self.viewModel.categoryList
            .bind(to: self.tableView.rx.items(cellIdentifier: CategoryCell.identifier, cellType: CategoryCell.self)) {
                
                _, item, cell in
                
                cell.titleLabel.text = item.title
                cell.colorView.backgroundColor = ColorUtil.hexStringToUIColor(item.color)
                
            }
        .disposed(by: disposeBag)
        
        // Input
        self.navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: {
                print("on카테고리 추가")
                self.viewModel.onAdd()
            })
            .disposed(by: self.disposeBag)
        
    }
    
}
