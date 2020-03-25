//
//  MainViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/09.
//  Copyright © 2019 avon. All rights reserved.
//

import Action
import Foundation
import RxCocoa
import RxDataSources
import RxSwift

// - MARK: Protocol
protocol MainViewModelType: BaseViewModelType {
    // VM to V
    var feedbackListOb: BehaviorRelay<[Feedback]> { get }
    
    // Scene
    /// 피드백 주제 리스트 화면으로 이동
    func onCategory()
    /// 피드백을 추가하는 화면으로 이동
    func onAddFeedback()
    /// 피드백을 수정하는 화면으로 이동
    func onModFeedback(_ selectedIndex: Int)
    /// 피드백 개선사항을 추가하는 화면으로 이동
    func onBoard(_ selectedIndex: Int)
    ///
    func onMyPage()
    ///
    func onFriendList()
    
    // CRUD
    /// 피드백을 삭제하는 함수
    func delFeedback(_ index: Int)
    
    // Network
    /// 사용자의 피드백만을 api서버에 조회 요청하는 함수
    func reqGetMyFeedbacks()
    /// 피드백 삭제를 api서버에 요청하는 함수
    func reqDelFeedback()
    /// 로그아웃
    func logout()
}

// - MARK: Variable and init
class MainViewModel: BaseViewModel, MainViewModelType {
    
    /// 뷰에 출력할 피드백 리스트 옵저버블
    let feedbackListOb: BehaviorRelay<[Feedback]>
    var feedbackList: [Feedback] = []
    var feedback = Feedback()
    /// 마지막으로 응답받은 피드백 ID 저장 변수
    let lastFID = 0
    
    override init() {
        self.feedbackListOb = BehaviorRelay<[Feedback]>(value: feedbackList)
        super.init()
    }
    
    
}

// - MARK: Scene
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
        SceneCoordinator.sharedInstance.push(scene: .editFeedbackView(feedbackViewModel))
    }
    
    func onModFeedback(_ selectedIndex: Int) {
        let feedbackViewModel = FeedbackViewModel()
        feedbackViewModel.feedback = self.feedbackList[selectedIndex]
        SceneCoordinator.sharedInstance.push(scene: .editFeedbackView(feedbackViewModel))
    }
    
    func onBoard(_ selectedIndex: Int) {
        let boardViewModel = BoardViewModel()
        // TODO: 아래의 3개 라인 코드를 이 영역에서 해도 되는지 의문
        boardViewModel.feedback = self.feedbackList[selectedIndex]
        boardViewModel.titleOb.onNext(self.feedbackList[selectedIndex].title)
        boardViewModel.dateOb.onNext(self.feedbackList[selectedIndex].date)
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
}

// MARK: CRUD
extension MainViewModel {
    func delFeedback(_ index: Int) {
        NWLog.sLog(contentName: "피드백 삭제", contents: nil)
        self.feedback = self.feedbackList[index]
        self.reqDelFeedback()
        self.feedbackList.remove(at: index)
        self.feedbackListOb.accept(self.feedbackList)
    }
    
    func logout() {
        UserDefaultsHelper.sharedInstantce.delCookie()
        reqLogout()
    }
}

// MARK: Network
extension MainViewModel {
    func reqGetMyFeedbacks() {
        APIHelper.sharedInstance.rxPullResponse(.getMyFeedbacks(lastID: String(lastFID)))
            .subscribe(onNext: { [weak self] in
                
                guard $0.isSuccess, let dataList = $0.dataDic else { return }
                
                for data in dataList {
                    let feedback = Feedback()
                    feedback.id = data["id"] as? Int ?? -1
                    feedback.uuid = data["user_uid"] as? String ?? ""
                    feedback.title = data["title"] as? String ?? ""
                    feedback.category = data["category"] as? Int ?? 0
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
                    
                    let dateStr: String = data["write_date"] as? String ?? ""
                    feedback.date = dateFormatter.date(from: dateStr) ?? Date()
                    
                    self?.feedbackList.append(feedback)
                }
                
                self?.feedbackListOb.accept(self?.feedbackList ?? [])
            })
            .disposed(by: self.disposeBag)
    }
    
    func reqDelFeedback() {
        APIHelper.sharedInstance.rxPullResponse(.delFeedback(String(self.feedback.id)))
            .subscribe(onNext: {
                NWLog.sLog(contentName: "피드백 삭제 요청 결과", contents: $0.msg)
            })
            .disposed(by: disposeBag)
    }
    
    func reqLogout() {
        APIHelper.sharedInstance.rxPullResponse(.logout)
            .subscribe(onNext: { [weak self] in
                NWLog.sLog(contentName: "로그아웃 결과", contents: $0.msg)
                self?.feedbackList.removeAll()
                self?.onLogin()
            })
            .disposed(by: disposeBag)
    }
    
}
