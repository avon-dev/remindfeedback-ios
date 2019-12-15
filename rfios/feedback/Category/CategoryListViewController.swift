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

class CategoryListViewController: UIViewController {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
   
}

extension CategoryListViewController {
    func setUI() {
        // 네비게이션 바 타이틀 설정
        self.navigationItem.title = "피드백 주제" // -TODO: 추후 해당 리터럴값을 뷰 모델에서 가져올 수 있도록 수정 필요
        
        // 네비게이션 바 색상 지정
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // 네비게이션 바 우측버튼
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: nil)
    }
}

extension CategoryListViewController {
    
    func setBinding() {
        
        // Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 { self?.viewModel.setScene(self ?? UIViewController()) }
            })
            .disposed(by: self.disposeBag)
        
        // Output
        self.viewModel.categoryListOb
            .bind(to:
            self.tableView.rx.items(cellIdentifier: CategoryCell.identifier, cellType: CategoryCell.self)) {
                
                _, item, cell in
                
                print(item)
                cell.onData.onNext(item)
                cell.viewModel = self.viewModel
            }
            .disposed(by: disposeBag)
        
        // Input
        
        // 화면 상단의 추가버튼을 눌렀을 때
        self.navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: {
                print("on주제 추가")
                self.viewModel.onAdd()
            })
            .disposed(by: self.disposeBag)
        
        // 테이블 뷰 셀을 좌측으로 스와이프할 때
        self.tableView.rx.itemDeleted
            .subscribe(onNext: {
                self.viewModel.delCategory($0.item)
            })
            .disposed(by: self.disposeBag)
        
    }
    
}
