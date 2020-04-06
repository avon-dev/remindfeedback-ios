//
//  MainViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/09.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol MainViewModelType: BaseViewModelType {
    // Output
    var feedbackListOutput: BehaviorRelay<[Feedback]> { get }
    
    // Scene
    /// 피드백 주제 리스트 화면으로 이동
    func onCategory()
    /// 피드백을 추가하는 화면으로 이동
    func onAddFeedback()
    /// 피드백을 수정하는 화면으로 이동
    func onModFeedback(_ selectedIndex: Int)
    /// 피드백 개선사항을 추가하는 화면으로 이동
    func onBoard(_ selectedIndex: Int)
    /// 마이페이지로 이동
    func onMyPage()
    /// 친구리스트로 이동
    func onFriendList()
    
    // CRUD
    /// 피드백 리스트에 새 피드백을 추가하는 함수
    func addFeedback(_ feedback: Feedback?)
    /// 피드백 리스트의 피드백을 수정하는 함수
    func modifyFeedback(_ feedback: Feedback?)
    /// 피드백 리스트를 가져오는 함수
    func fetchFeedbackList()
    /// 피드백을 삭제하는 함수
    func removeFeedback(_ index: Int)
    /// 로그아웃
    func logout()
}

class MainViewModel: BaseViewModel, MainViewModelType {
    
    let feedbackListOutput: BehaviorRelay<[Feedback]>
    var feedbackList: [Feedback] = []
    var feedback = Feedback()
    var selectedIndex = -1
    /// 마지막으로 응답받은 피드백 ID 저장 변수
    var lastFID = 0
    /// 피드백을 가져오는 중인지 확인하는 함수
    var isFetching = false
    
    override init() {
        self.feedbackListOutput = BehaviorRelay<[Feedback]>(value: feedbackList)
        super.init()
    }
}

// MARK: Scene
extension MainViewModel {
    
    func onLogin() {
        let loginViewModel = LoginViewModel()
        SceneCoordinator.sharedInstance.present(scene: .loginView(loginViewModel))
    }
    
    func onCategory() {
        let categoryViewModel = CategoryViewModel()
        SceneCoordinator.sharedInstance.push(scene: .categoryView(categoryViewModel))
    }
    
    func onAddFeedback() {
        let feedbackViewModel = FeedbackViewModel()
        feedbackViewModel.mainViewModel = self
        SceneCoordinator.sharedInstance.push(scene: .editFeedbackView(feedbackViewModel))
    }
    
    func onModFeedback(_ selectedIndex: Int) {
        let feedbackViewModel = FeedbackViewModel()
        self.selectedIndex = selectedIndex
        feedbackViewModel.mainViewModel = self
        feedbackViewModel.feedback = self.feedbackList[selectedIndex]
        SceneCoordinator.sharedInstance.push(scene: .editFeedbackView(feedbackViewModel))
    }
    
    func onBoard(_ selectedIndex: Int) {
        let boardViewModel = BoardViewModel()
        // TODO: 아래의 3개 라인 코드를 이 영역에서 해도 되는지 의문
        boardViewModel.feedback = self.feedbackList[selectedIndex]
        boardViewModel.titleOutput.onNext(self.feedbackList[selectedIndex].title)
        boardViewModel.dateOutput.onNext(self.feedbackList[selectedIndex].date)
        SceneCoordinator.sharedInstance.push(scene: .boardView(boardViewModel))
    }
    
    func onMyPage() {
        let myPageViewModel = MyPageViewModel()
        SceneCoordinator.sharedInstance.push(scene: .myPageView(myPageViewModel))
    }
    
    func onFriendList() {
        let friendListViewModel = FriendViewModel()
        SceneCoordinator.sharedInstance.push(scene: .friendListView(friendListViewModel))
    }
    
    private func bindAlert(title: String, text: String) {
        SceneCoordinator.sharedInstance
            .getCurrentViewController()?
            .alert(title: title, text: text)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

// MARK: Control
extension MainViewModel {
    
    func addFeedback(_ feedback: Feedback?) {
        guard let feedback = feedback else { return }
        feedbackList.insert(feedback, at: 0) 
        feedbackListOutput.accept(feedbackList)
    }
    
    func modifyFeedback(_ feedback: Feedback?) {
        guard let feedback = feedback else { return }
        feedbackList[selectedIndex] = feedback
        feedbackListOutput.accept(feedbackList)
    }
    
    func fetchFeedbackList() {
        requestList()
    }
    
    func removeFeedback(_ index: Int) {
        self.selectedIndex = index
        self.feedback = self.feedbackList[index]
        self.requestRemoval()
    }
    
    func logout() {
        UserDefaultsHelper.sharedInstantce.delCookie()
        requestLogout()
    }
}

// MARK: Network
extension MainViewModel {
    func requestList() {
        
        guard !isFetching else { return }
        
        isFetching = true
        
        APIHelper.sharedInstance
            .rxPullResponse(.getMyFeedbacks(lastID: String(lastFID)))
            .subscribe(onNext: { [weak self] in
                
                guard $0.isSuccess, let dataList = $0.dataDic else {
                    self?.bindAlert(title: "안내", text: $0.msg ?? "알 수 없는 오류가 발생했습니다.")
                    return
                }
                dataList.forEach {
                    let feedback = Feedback($0)
                    self?.feedbackList.append(feedback)
                }
                self?.lastFID = self?.feedbackList.last?.id ?? self?.lastFID ?? 0
                self?.feedbackListOutput.accept(self?.feedbackList ?? [])
                }, onDisposed: { [weak self] in
                    self?.isFetching = false
            }).disposed(by: self.disposeBag)
    }
    
    func requestRemoval() {
        APIHelper.sharedInstance.rxPullResponse(.delFeedback(String(self.feedback.id)))
            .subscribe(onNext: { [weak self] in
                guard $0.isSuccess else {
                    self?.bindAlert(title: "안내", text: $0.msg ?? "알 수 없는 오류가 발생했습니다.")
                    return
                }
                
                self?.feedbackList.remove(at: self?.selectedIndex ?? -1)
                self?.feedbackListOutput.accept(self?.feedbackList ?? [])
            }).disposed(by: disposeBag)
    }
    
    func requestLogout() {
        APIHelper.sharedInstance.rxPullResponse(.logout)
            .subscribe(onNext: { [weak self] in
                guard $0.isSuccess else {
                    self?.bindAlert(title: "안내", text: $0.msg ?? "알 수 없는 오류가 발생했습니다.")
                    return
                }
                
                self?.feedbackList.removeAll()
                self?.onLogin()
            }).disposed(by: disposeBag)
    }
    
}
