//
//  SideMenuViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/09.
//  Copyright © 2019 avon. All rights reserved.
//

//import Hero
import RxCocoa
import RxGesture
import RxSwift
import RxViewController
import UIKit

import SideMenuSwift

class SideBarViewController: UIViewController {
    
    var viewModel: MainViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: MainViewModelType = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = MainViewModel()
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var mypageBtn: UIButton!
    @IBOutlet weak var friendListBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinding()
    }
        
    @IBAction func showMainView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

// MARK: Binding
extension SideBarViewController {
    
        
    func setBinding() {
        
        // MARK: Scene
        
        // MARK: Input
        
        // 카테고리 버튼
        categoryBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.sideMenuController?.hideMenu()
                self?.viewModel.onCategory()
            })
            .disposed(by: self.disposeBag)
        
        // 마이페이지 버튼
        mypageBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.sideMenuController?.hideMenu()
                self?.viewModel.onMyPage()
            })
            .disposed(by: self.disposeBag)
        
        // 친구리스트 버튼
//        friendListBtn.rx.tapGesture()
//            .when(.recognized)
//            .subscribe(onNext: { [weak self] in
//                self?.sideMenuController?.hideMenu()
//                self?.viewModel.onFriendList()
//            })
//            .disposed(by: disposeBag)
        friendListBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.sideMenuController?.hideMenu()
                self?.viewModel.onFriendList()
            })
            .disposed(by: disposeBag)
        
        // 로그아웃 버튼
        logoutBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.sideMenuController?.hideMenu()
                self?.viewModel.logout()
            })
            .disposed(by: disposeBag)
            
            
    }
    
}
