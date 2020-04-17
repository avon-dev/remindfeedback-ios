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
    
    func fetchMyPage()
    func modifyNickname(_ nickname: String)
    func modifyIntroduction(_ introduction: String)
    func modifyPortrait(_ image: UIImage)
}

class MyPageViewModel: BaseViewModel, MyPageViewModelType {
    
    var user = User([:])
    
    let userOutput: BehaviorSubject<User>
    
    override init() {
        userOutput = BehaviorSubject<User>(value: user)
        super.init()
    }
    
}

// MARK: Scene
extension MyPageViewModel {
    private func bindAlert(title: String, text: String) {
        SceneCoordinator.sharedInstance
            .getCurrentViewController()?
            .alert(title: title, text: text)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

// MARK: CRUD
extension MyPageViewModel {
    func fetchMyPage() {
        requestMyPage()
    }
    
    func modifyNickname(_ nickname: String) {
        requestNicknameModification(user.nickname)
    }
    
    func modifyIntroduction(_ introduction: String) {
        requestIntroductionModification(user.introduction)
    }
    
    func modifyPortrait(_ image: UIImage) {
        requestPortraitModification(image)
    }
}

// MARK: Network
extension MyPageViewModel {
    
    func requestMyPage() {
        
        SceneCoordinator.sharedInstance.show()
        
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
        
        SceneCoordinator.sharedInstance.show()
        
        APIHelper.sharedInstance.rxPullResponse(.modNickName(["nickname":nickname]))
            .subscribe(onNext: { [weak self] in
                if $0.isSuccess {
                    self?.user = User($0.data as? [String:String])
                    self?.userOutput.onNext(self?.user ?? User([:]))
                }
            }, onDisposed: {
                SceneCoordinator.sharedInstance.hide()
            })
            .disposed(by: disposeBag)
    }
    
    func requestIntroductionModification(_ introduction: String) {
        
        SceneCoordinator.sharedInstance.show()
        
        APIHelper.sharedInstance.rxPullResponse(.modIntro(["introduction":introduction]))
            .subscribe(onNext: { [weak self] in
                guard $0.isSuccess else {
                    self?.bindAlert(title: "안내", text: $0.msg ?? "알 수 없는 오류가 발생했습니다.")
                    return
                }
                
                self?.user = User($0.data as? [String:String])
                self?.userOutput.onNext(self?.user ?? User([:]))
            }, onDisposed: {
                SceneCoordinator.sharedInstance.hide()
            })
            .disposed(by: disposeBag)
    }
    
    func requestPortraitModification(_ image: UIImage) {
        
        SceneCoordinator.sharedInstance.show()
        
        APIHelper.sharedInstance.rxUploadImage(.modPortrait(image: image))
            .subscribe(onDisposed: {
                SceneCoordinator.sharedInstance.hide()
            })
            .disposed(by: disposeBag)
    }
}
