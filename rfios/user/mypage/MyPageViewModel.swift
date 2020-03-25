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
    var userOb: BehaviorSubject<User> { get }
    
    func reqGetMyPage()
    func reqModNickName(_ nickname: String)
    func reqModIntro(_ introduction: String)
    func reqModPortrait(_ image: UIImage)
}

class MyPageViewModel: BaseViewModel, MyPageViewModelType {
    
    var user = User([:])
    
    let userOb: BehaviorSubject<User>
    
    override init() {
        userOb = BehaviorSubject<User>(value: user)
        super.init()
    }
    
}

// MARK: Network
extension MyPageViewModel {
    
    func reqGetMyPage() {
        return APIHelper.sharedInstance.rxPullResponse(.getMyPage)
            .subscribe(onNext: { [weak self] in
                if $0.isSuccess {
                    self?.user = User($0.data as? [String:String])
                    self?.userOb.onNext(self?.user ?? User([:]))
                }
            }, onCompleted: {
                SceneCoordinator.sharedInstance.remove()
            })
            .disposed(by: disposeBag)
    }
    
    func reqModNickName(_ nickname: String) {
        APIHelper.sharedInstance.rxPullResponse(.modNickName(["nickname":nickname]))
            .subscribe(onNext: { [weak self] in
                if $0.isSuccess {
                    self?.user = User($0.data as? [String:String])
                    self?.userOb.onNext(self?.user ?? User([:]))
                }
            }, onCompleted: {
                SceneCoordinator.sharedInstance.remove()
            })
            .disposed(by: disposeBag)
    }
    
    func reqModIntro(_ introduction: String) {
        APIHelper.sharedInstance.rxPullResponse(.modIntro(["introduction":introduction]))
            .subscribe(onNext: { [weak self] in
                if $0.isSuccess {
                    self?.user = User($0.data as? [String:String])
                    self?.userOb.onNext(self?.user ?? User([:]))
                }
            }, onCompleted: {
                SceneCoordinator.sharedInstance.remove()
            })
            .disposed(by: disposeBag)
    }
    
    func reqModPortrait(_ image: UIImage) {
        APIHelper.sharedInstance.rxUploadImage(.modPortrait(image: image))
            .subscribe(onCompleted: {
                SceneCoordinator.sharedInstance.remove()
            })
            .disposed(by: disposeBag)
    }
}
