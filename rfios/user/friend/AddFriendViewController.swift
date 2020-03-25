//
//  AddFriendViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/03/15.
//  Copyright © 2020 avon. All rights reserved.
//

import RxCocoa
import RxGesture
import RxKingfisher
import RxSwift
import RxViewController
import UIKit

class AddFriendViewController: UIViewController {

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
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var portraitImage: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addFriendBtn: UIButton!
    @IBOutlet weak var statusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBinding()
    }

}

// MARK: UI
extension AddFriendViewController {
    func setUI() {
        setNavUI()
        setHidden()
    }
    
    func setNavUI() {
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "친구찾기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기", style: .done, target: nil, action: nil)
    }
    
    func setHidden() {
        portraitImage.isHidden = true
        nicknameLabel.isHidden = true
        emailLabel.isHidden = true
        addFriendBtn.isHidden = true
        statusLabel.isHidden = true
    }
}

// MARK: Binding
extension AddFriendViewController {
    func setBinding() {
        // MARK: Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.viewModel.setScene(self ?? UIViewController())
                }
            })
            .disposed(by: self.disposeBag)

        // MARK: Output
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.setHidden()
                SceneCoordinator.sharedInstance.show()
                self?.viewModel.findFriend()
            })
            .disposed(by: disposeBag)
        
        emailField.rx.text.orEmpty
            .bind(to: self.viewModel.emailInput)
            .disposed(by: disposeBag)
        
        addFriendBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                SceneCoordinator.sharedInstance.show()
                self?.viewModel.addFriend()
            })
            .disposed(by: disposeBag)
        
        // MARK: Input
        viewModel.msgOutput
            .filter{ !$0.isEmpty }
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.bindAlert(title: "안내", content: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.portraitOutput
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.portraitImage.kf.setImage(with: $0, placeholder: UIImage(named: "user-black"))
            })
            .disposed(by: disposeBag)
        
        viewModel.nicknameOutput
            .asDriver()
            .drive(self.nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.emailOutput
            .asDriver()
            .drive(self.emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.typeOutput
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                
                let type = FriendType(rawValue: $0)
                
                if type != nil {
                    self?.portraitImage.isHidden = false
                    self?.portraitImage.layer.cornerRadius = (self?.portraitImage.frame.height ?? 40)/2
                    self?.nicknameLabel.isHidden = false
                    self?.emailLabel.isHidden = false
                }
                
                switch type {
                case .abNone, .bDenial, .bRequest:
                    self?.addFriendBtn.isHidden = false
                    break
                case .aRequest:
                    self?.statusLabel.isHidden = false
                    self?.statusLabel.text = "이미 친구요청 중입니다."
                    break
                case .abfriend:
                    self?.statusLabel.isHidden = false
                    self?.statusLabel.text = "이미 친구추가되었습니다."
                    break
                case .aBlock:
                    self?.statusLabel.isHidden = false
                    self?.statusLabel.text = "해당 친구를 차단하셨습니다."
                    break
                case .bBlock:
                    self?.statusLabel.isHidden = false
                    self?.statusLabel.text = "친구로부터 차단되셨습니다."
                    break
                case .block:
                    self?.statusLabel.isHidden = false
                    self?.statusLabel.text = "서로 차단한 상태입니다."
                    break
                default:
                    break
                }
                
            })
            .disposed(by: disposeBag)
        
    
    }
    
    func bindAlert(title: String, content: String) {
        alert(title: title, text: content)
            .subscribe()
            .disposed(by: disposeBag)
    }
}
