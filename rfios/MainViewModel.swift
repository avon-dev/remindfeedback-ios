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

protocol MainViewModelType: BaseViewModelType {
    // Output
    var feedbackListOb: BehaviorRelay<[Feedback]> { get }
    
    // Scene
    func onCategory()
    func onAddFeedback()
    func onModFeedback(_ selectedIndex: Int)
    func onBoard(_ selectedIndex: Int)
    
    // CRUD
    func delFeedback(_ index: Int)
    
    // Network
    func reqGetMyFeedbacks()
    func reqDelFeedback()
}

// - MARK: Variable and init
class MainViewModel: BaseViewModel, MainViewModelType {
    
    let feedbackListOb: BehaviorRelay<[Feedback]>
    var feedbackList: [Feedback] = []
    var feedback = Feedback()
    let lastFID = 0
    
    override init() {
        self.feedbackListOb = BehaviorRelay<[Feedback]>(value: feedbackList)
        super.init()
    }
    
    
}

// - MARK: Scene
extension MainViewModel {
    
    /// 피드백 주제 리스트 화면으로 이동
    func onCategory() {
        let categoryViewModel = CategoryViewModel()
        SceneCoordinator.sharedInstance.showCategoryView(categoryViewModel)
    }
    
    /// 피드백을 추가하는 화면으로 이동
    func onAddFeedback() {
        let feedbackViewModel = FeedbackViewModel()
        SceneCoordinator.sharedInstance.showEditFeedbackView(feedbackViewModel)
    }
    
    /// 피드백을 수정하는 화면으로 이동
    func onModFeedback(_ selectedIndex: Int) {
        let feedbackViewModel = FeedbackViewModel()
        feedbackViewModel.feedback = self.feedbackList[selectedIndex]
        SceneCoordinator.sharedInstance.showEditFeedbackView(feedbackViewModel)
    }
    
    /// 피드백 개선사항을 추가하는 화면으로 이동
    func onBoard(_ selectedIndex: Int) {
        let boardViewModel = BoardViewModel()
        SceneCoordinator.sharedInstance.showBoardView(boardViewModel)
    }
}

// - MARK: CRUD
extension MainViewModel {
    func delFeedback(_ index: Int) {
        NWLog.sLog(contentName: "피드백 삭제", contents: nil)
        self.feedback = self.feedbackList[index]
        self.reqDelFeedback()
        self.feedbackList.remove(at: index)
        self.feedbackListOb.accept(self.feedbackList)
    }
}

// - MARK: Network
extension MainViewModel {
    func reqGetMyFeedbacks() {
        APIHelper.sharedInstance.rxPullResponse(.getMyFeedbacks(lastId: String(lastFID)))
            .subscribe(onNext: { [weak self] in
                guard let dataList = $0.dataDic else { return }
                
//                self?.feedbackList.removeAll()
                
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
            .disposed(by: self.disposeBag)
    }
}
