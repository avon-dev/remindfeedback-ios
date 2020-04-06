//
//  AdviserListViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/04/06.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol AdviserListViewModelType: BaseViewModelType {
    // Output
    var adviserListOutput: BehaviorRelay<[User]> { get }
    
    var selectedIndex: Int? { get set }
    
    // CRUD
    func fetchList()
}

class AdviserListViewModel: BaseViewModel, AdviserListViewModelType {
    
    let adviserListOutput: BehaviorRelay<[User]>
    var adviserList: [User] = []
    var selectedIndex: Int? = -1
    
    override init() {
        adviserListOutput = BehaviorRelay<[User]>(value: [])
        super.init()
    }
    
}

// MARK: Scene
extension AdviserListViewModel {
    private func bindAlert(title: String, text: String) {
        SceneCoordinator.sharedInstance
            .getCurrentViewController()?
            .alert(title: title, text: text)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

// MARK: CRUD
extension AdviserListViewModel {
    func fetchList() {
        requestList()
    }
}

// MARK: Network
extension AdviserListViewModel {
    private func requestList() {
        
        SceneCoordinator.sharedInstance.show()
        
        APIHelper.sharedInstance
            .rxPullResponse(.getFriends)
            .subscribe(onNext: { [weak self] in
                
                guard $0.isSuccess, let dataList = $0.dataDic else {
                    self?.bindAlert(title: "안내"
                        , text: $0.msg ?? "알 수 없는 오류가 발생했습니다.")
                    return
                }
                
                self?.adviserList = dataList.map { User($0) }
                    .filter { $0.type == FriendType.abfriend.rawValue }
                
                self?.adviserListOutput.accept(self?.adviserList ?? [])
                }, onDisposed: { 
                    SceneCoordinator.sharedInstance.hide()
            }).disposed(by: disposeBag)
    }
}
