//
//  MyPageViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/03/05.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol MyPageViewModelType: BaseViewModelType {
    var user: User { get set }
    var userOutput: BehaviorSubject<User> { get }
    
    func requestMyPage()
    func requestNicknameModification(_ nickname: String)
    func requestIntroductionModification(_ introduction: String)
    func requestPortraitModification(_ image: UIImage)
}

class MyPageViewModel: BaseViewModel, MyPageViewModelType {
    
    var user = User([:])
    
    let userOutput: BehaviorSubject<User>
    
    override init() {
        userOutput = BehaviorSubject<User>(value: user)
        super.init()
    }
    
}

// MARK: Network
extension MyPageViewModel {
    
    func requestMyPage() {
        return APIHelper.sharedInstance.rxPullResponse(.getMyPage)
            .subscribe(onNext: { [weak self] in
                if $0.isSuccess {
                    self?.user = User($0.data as? [String:String])
                    self?.userOutput.onNext(self?.user ?? User([:]))
                }
            }, onCompleted: {
                SceneCoordinator.sharedInstance.hide()
            })
            .disposed(by: disposeBag)
    }
    
    func requestNicknameModification(_ nickname: String) {
        APIHelper.sharedInstance.rxPullResponse(.modNickName(["nickname":nickname]))
            .subscribe(onNext: { [weak self] in
                if $0.isSuccess {
                    self?.user = User($0.data as? [String:String])
                    self?.userOutput.onNext(self?.user ?? User([:]))
                }
            }, onCompleted: {
                SceneCoordinator.sharedInstance.hide()
            })
            .disposed(by: disposeBag)
    }
    
    func requestIntroductionModification(_ introduction: String) {
        APIHelper.sharedInstance.rxPullResponse(.modIntro(["introduction":introduction]))
            .subscribe(onNext: { [weak self] in
                if $0.isSuccess {
                    self?.user = User($0.data as? [String:String])
                    self?.userOutput.onNext(self?.user ?? User([:]))
                }
            }, onCompleted: {
                SceneCoordinator.sharedInstance.hide()
            })
            .disposed(by: disposeBag)
    }
    
    func requestPortraitModification(_ image: UIImage) {
        APIHelper.sharedInstance.rxUploadImage(.modPortrait(image: image))
            .subscribe(onCompleted: {
                SceneCoordinator.sharedInstance.hide()
            })
            .disposed(by: disposeBag)
    }
}
