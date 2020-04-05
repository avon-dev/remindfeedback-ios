//
//  FriendListViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/18.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift

typealias UserSection = SectionModel<String, User>

protocol FriendViewModelType: BaseViewModelType {
    
    // Output
    var friendListOutput: BehaviorRelay<[User]> { get }
    
    var portraitOutput: BehaviorRelay<URL> { get }
    var nicknameOutput: BehaviorRelay<String> { get }
    var emailOutput: BehaviorRelay<String> { get }
    var typeOutput: BehaviorRelay<Int> { get }
    
    var friendSectionOutput: BehaviorRelay<[UserSection]> { get }
    
    /// Behavior로 하면 FriendListVC의 불필요한 메시지로 alert로 띄워버린다.
    var msgOutput: PublishRelay<String> { get }
    
    // Input
    var emailInput: BehaviorSubject<String> { get }
    
    // Scene
    func onAddFriend()
    func onRequestFriend()
    func onBlockFriend()
    
    // CRUD
    func fetchFriendList()
    func findFriend()
    func addFriend()
}

class FriendViewModel: BaseViewModel, FriendViewModelType {
    
    // Output
    let friendListOutput: BehaviorRelay<[User]>
    let friendSectionOutput: BehaviorRelay<[UserSection]>
    
    let portraitOutput: BehaviorRelay<URL>
    let nicknameOutput: BehaviorRelay<String>
    let emailOutput: BehaviorRelay<String>
    let typeOutput: BehaviorRelay<Int>
    
    let msgOutput: PublishRelay<String>

    // Input
    let emailInput: BehaviorSubject<String>
    
    private var email = ""
    private var friend = User()
    private var friendList: [User] = []
    
    override init() {
        emailInput = BehaviorSubject<String>(value: "")
        
        friendListOutput = BehaviorRelay<[User]>(value: [])
        friendSectionOutput = BehaviorRelay<[UserSection]>(value: [])
        
        portraitOutput = BehaviorRelay<URL>(value: URL(string: RemindFeedback.imgURL)!)
        nicknameOutput = BehaviorRelay<String>(value: "")
        emailOutput = BehaviorRelay<String>(value: "")
        typeOutput = BehaviorRelay<Int>(value: -2)
        
        msgOutput = PublishRelay<String>()
        
        super.init()
        
        emailInput.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.email = $0
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: Scene
extension FriendViewModel {
    func onAddFriend() {
        SceneCoordinator.sharedInstance.push(scene: .addFriendView(self))
    }
    
    func onRequestFriend() {
        SceneCoordinator.sharedInstance.push(scene: .requestFriendView(self))
    }
    
    func onBlockFriend() {
        SceneCoordinator.sharedInstance.push(scene: .blockFriendView(self))
    }
}

// MARK: CRUD
extension FriendViewModel {
    
    func fetchFriendList() {
        reqList()
    }
    
    func findFriend() {
        reqFind()
    }
    
    func addFriend() {
        reqAdd()
    }
}

// MARK: Network
extension FriendViewModel {
    
    func reqList() {
        APIHelper.sharedInstance
            .rxPullResponse(.getFriends)
            .subscribe(onNext: { [weak self] in
                guard $0.isSuccess, let dataList = $0.dataDic else {
                    SceneCoordinator.sharedInstance.hide()
                    self?.msgOutput.accept($0.msg ?? "알 수 없는 오류가 발생했습니다.")
                    return
                }
                
//                self?.friendList = (self?.friendList ?? []) + dataList.map{ User($0) }
                self?.friendList = dataList.map{ User($0) }
                self?.friendListOutput.accept(self?.friendList ?? [])
                
            }, onCompleted: {
                SceneCoordinator.sharedInstance.hide()
            })
            .disposed(by: disposeBag)
    }
    
    func reqFind() {
        guard !email.isEmpty, email.validateEmail() else {
            self.msgOutput.accept("올바른 이메일을 입력해주세요.")
            return
        }
        
        APIHelper.sharedInstance
            .rxPullResponse(.findFriend(["email" : email]))
            .subscribe(onNext: { [weak self] in
                
                guard $0.isSuccess, let data = $0.data else {
                    SceneCoordinator.sharedInstance.hide()
                    self?.msgOutput.accept($0.msg ?? "알 수 없는 오류가 발생했습니다.")
                    return
                }
                
                self?.friend = User(data)
                
                let url =
                    URL(string: RemindFeedback.imgURL + (self?.friend.portrait ?? ""))!
                self?.portraitOutput.accept(url)
                self?.nicknameOutput.accept(self?.friend.nickname ?? "")
                self?.emailOutput.accept(self?.friend.email ?? "")
                if self?.friend.type == 1,
                    self?.friend.uid != UserDefaultsHelper.sharedInstantce.getUUID() {
                    self?.friend.type = 6
                }
                self?.typeOutput.accept(self?.friend.type ?? -2)
                    
            }, onCompleted: {
                SceneCoordinator.sharedInstance.hide()
            })
            .disposed(by: disposeBag)
    }
    
    func reqAdd() {
        guard !friend.uid.isEmpty else { return }
        
        APIHelper.sharedInstance
            .rxPullResponse(.addFriend(["user_uid" : friend.uid]))
            .subscribe(onNext: { [weak self] in
                guard $0.isSuccess, let data = $0.data else {
                    SceneCoordinator.sharedInstance.hide()
                    self?.msgOutput.accept($0.msg ?? "알 수 없는 오류가 발생했습니다.")
                    return
                }
            }, onCompleted: {
                SceneCoordinator.sharedInstance.hide()
                SceneCoordinator.sharedInstance.pop()
            })
            .disposed(by: disposeBag)
    }
}
