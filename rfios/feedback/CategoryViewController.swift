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
        setBinding()
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
        
    }
    
}
