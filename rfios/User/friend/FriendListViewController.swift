//
//  FriendListViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/18.
//  Copyright © 2019 avon. All rights reserved.
//

import Floaty
import Kingfisher
import RxCocoa
import RxSwift
import RxViewController
import UIKit

class FriendListViewController: UIViewController {
    
    var viewModel: FriendViewModelType
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    init(viewModel: FriendViewModelType = FriendViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = FriendViewModel()
        super.init(coder: aDecoder)
    }
    
    /// 플로팅 버튼
    let floatingBtn = Floaty()

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
extension FriendListViewController {
    func setUI() {
        setNavUI()
        
        let cellName = UINib(nibName: "FriendCell", bundle: nil)
        tableView.register(cellName, forCellReuseIdentifier: "friendCell")
        tableView.estimatedRowHeight = 52.0
        
        self.floatingBtn.addItem("친구요청관리", icon: nil, handler: {
            item in
            self.viewModel.onRequestFriend()
        })
        
        self.floatingBtn.addItem("친구차단관리", icon: nil, handler: {
            item in
            self.viewModel.onBlockFriend()
        })
        
        // 화면에 플로팅 버튼 추가
        self.view.addSubview(self.floatingBtn)
    }
    
    func setNavUI() {
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.rightBarButtonItem =
            UIBarButtonItem.init(image: UIImage(named: "add-friend"), style: .done, target: nil, action: nil)
    }
    
    func updateUI() {
        navigationItem.title = "친구목록"
    }
    
}

// MARK: Binding
extension FriendListViewController {
    func setBinding() {
        
        // MARK: Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.viewModel.setScene(self ?? UIViewController())
                    SceneCoordinator.sharedInstance.show()
                    self?.viewModel.setFriendList()
                }
            })
            .disposed(by: self.disposeBag)
        
        // MARK: Output
        viewModel.friendListOutput
            .bind(to: tableView.rx.items(cellIdentifier: FriendCell.identifier, cellType: FriendCell.self)) { [weak self] index, item, cell in
                
                cell.onData.onNext(item)
                cell.index = index
                cell.viewModel = self?.viewModel
                
            }
            .disposed(by: disposeBag)
        
//        tableView.rx
//            .modelSelected(String.self)
//            .subscribe(onNext: { model in
//                let viewController = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "friendVC")
//                viewController.modalPresentationStyle = .fullScreen
//                self.present(viewController, animated: false, completion: nil)
//            })
//            .disposed(by: disposeBag)
        
        // Input
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.onAddFriend() 
            })
            .disposed(by: disposeBag)
        
        
        
        
    }
}
