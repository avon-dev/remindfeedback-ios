//
//  AdviserListViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/04/06.
//  Copyright © 2020 avon. All rights reserved.
//

import RxCocoa
import RxSwift
import RxViewController
import SnapKit
import UIKit

class AdviserListViewController: UIViewController {
    
    var viewModel: AdviserListViewModelType
    var disposeBag = DisposeBag()
    
    lazy var tableView: UITableView = {
        let tbl = UITableView()
        tbl.register(AdviserCell.self, forCellReuseIdentifier: AdviserCell.identifier)
        tbl.rowHeight = 60.0
        tbl.estimatedRowHeight = 60.0
        view.addSubview(tbl)
        
        return tbl
    }()
    
    init(viewModel: AdviserListViewModelType = AdviserListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = AdviserListViewModel()
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "adviserListView"
        setUI()
        setBinding()
    }
    
}

// MARK: UI
extension AdviserListViewController {
    func setUI() {
        setNavUI()
        setConstraints()
    }
    
    func setNavUI() {
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "조언자 선택"
        navigationItem.rightBarButtonItem =
            UIBarButtonItem.init(title: "완료", style: .done, target: self, action: nil)
    }
    
    func setConstraints() {
        tableView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Binding
extension AdviserListViewController {
    func setBinding() {
        
        // MARK: Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.viewModel.setScene(self ?? UIViewController())
                    self?.viewModel.fetchList()
                }
            }).disposed(by: disposeBag)
        
        // MARK: Output
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] in
                self?.tableView.cellForRow(at: $0)?.backgroundColor = .gray
            }).disposed(by: disposeBag)
        
        tableView.rx.itemDeselected
            .subscribe(onNext: { [weak self] in
                self?.tableView.cellForRow(at: $0)?.backgroundColor = .clear
            }).disposed(by: disposeBag)
        
        // MARK: Input
        viewModel.adviserListOutput
            .bind(to: tableView.rx.items(cellIdentifier: AdviserCell.identifier
                , cellType: AdviserCell.self)) { [weak self] index, item, cell in
                    
                    cell.dataInput.onNext(item)
                    cell.viewModel = self?.viewModel
                    cell.index = index
            }.disposed(by: disposeBag)
        
    }
} 
