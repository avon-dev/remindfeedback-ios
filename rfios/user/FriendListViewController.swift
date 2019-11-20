//
//  FriendListViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/18.
//  Copyright © 2019 avon. All rights reserved.
//

import RxCocoa
import RxSwift
import RxViewController
import UIKit

class FriendListViewController: UIViewController {
    
    var viewModel: FriendListViewModelType
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    init(viewModel: FriendListViewModelType = FriendListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = FriendListViewModel()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let cellName = UINib(nibName: "FriendCell", bundle: nil)
        tableView.register(cellName, forCellReuseIdentifier: "friendCell")
        tableView.estimatedRowHeight = 80.0
        setBinding()
    }
    
    func setBinding() {
        
        viewModel.friendList
            .bind(to: tableView.rx.items(cellIdentifier: "friendCell", cellType: FriendCell.self)) {
                
                _, item, cell in
                
                
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { model in
                let viewController = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "friendVC")
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func pop(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
