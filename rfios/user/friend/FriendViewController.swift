//
//  FriendViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/03/24.
//  Copyright © 2020 avon. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import RxViewController
import UIKit

class FriendViewController: UIViewController {

    var viewModel: FriendViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: FriendViewModelType = FriendViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = FriendViewModel()
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    @IBOutlet weak var portraitImg: UIImageView!
    @IBOutlet weak var portraitBtn: UIButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var blockSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBinding()
    }

}

// MARK: UI
extension FriendViewController {
    func setUI() {
        setNavUI()
    }
    
    func setNavUI() {
        self.navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "친구정보"
    }
}

// MARK: Binding
extension FriendViewController {
    func setBinding() {
        // MARK: Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.viewModel.setScene(self ?? UIViewController())
                    SceneCoordinator.sharedInstance.show()
//                    self?.viewModel.reqGetMyPage()
                }
            })
            .disposed(by: self.disposeBag)
        
        // MARK: Input
        // 로그인한 유저 정보 옵저버블
//        viewModel.userOb
//            .asObservable()
//            .subscribe(onNext: { [weak self] in
//                self?.nicknameLabel.text = $0.nickname
//                self?.emailLabel.text = $0.email
//                if !$0.introduction.isEmpty { self?.introLabel.text = $0.introduction }
//                if !$0.portrait.isEmpty {
//                    self?.portraitImg.kf.setImage(with: URL(string: RemindFeedback.imgURL + $0.portrait))
//                    self?.portraitImg.layer.cornerRadius = (self?.portraitImg.frame.height ?? 40)/2
//                    self?.portraitImg.clipsToBounds = true
//                }
//            })
//            .disposed(by: disposeBag)
    }
}
