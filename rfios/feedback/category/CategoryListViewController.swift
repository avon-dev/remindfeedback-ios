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
        updateUI()
    }
   
}

// MARK: UI
extension CategoryListViewController {
    func setUI() {
        setNavUI()
    }
    
    func setNavUI() {
        navigationController?.navigationBar.topItem?.title = ""
        
        // 네비게이션 바 우측버튼
        if viewModel.isSelection {
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: nil)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: nil)
        }
    }
    
    func updateUI() {
        self.navigationItem.title = "피드백 주제"
    }
}

// MARK: Binding
extension CategoryListViewController {
    
    func setBinding() {
        
        // MARK: Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 { self?.viewModel.setScene(self ?? UIViewController()) }
            })
            .disposed(by: self.disposeBag)
        
        // MARK: Output
        self.viewModel.categoryListOb
            .bind(to:
            self.tableView.rx.items(cellIdentifier: CategoryCell.identifier, cellType: CategoryCell.self)) { index, item, cell in
                
                cell.onData.onNext(item)
                cell.index = index
                cell.viewModel = self.viewModel
                if self.viewModel.isSelection {
                    cell.modifyBtn.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: Input
        
        // 화면 상단의 추가버튼을 눌렀을 때
        self.navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                if self?.viewModel.isSelection ?? false {
                    print("주제 선택 완료")
                    if let vm = self?.viewModel.feedbackViewModel {
                        self?.viewModel.selCategory()
                        self?.navigationController?.popViewController(animated: true)
                    }
                } else {
                    print("on주제 추가")
                    self?.viewModel.onAdd()
                }
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
