//
//  BoardViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/01/21.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol BoardViewModelType: BaseViewModelType {
    
    // Output
    var titleOutput: BehaviorSubject<String> { get }
    var dateOutput: BehaviorSubject<Date> { get }
    var cardListOutput: BehaviorRelay<[Card]> { get }
    
    // Scene
    func onTextCard(_ index: Int)
    func onEditCard()
    func onEditTextCard()
    
    // CRUD
    func fetchList()
    func updateList()
    func deleteCard(_ index: Int)
    
}

class BoardViewModel: BaseViewModel, BoardViewModelType {
    
    var feedback = Feedback()
    let titleOutput: BehaviorSubject<String>
    let dateOutput: BehaviorSubject<Date>
    
    var cardList = [Card]()
    let cardListOutput: BehaviorRelay<[Card]>
    var selectedIndex = -1
    
    override init() {
        self.titleOutput = BehaviorSubject.init(value: "")
        self.dateOutput = BehaviorSubject.init(value: Date())
        self.cardListOutput = BehaviorRelay<[Card]>(value: cardList)
        super.init()
    }
    
}

// MARK: Scene
extension BoardViewModel {
    func onTextCard(_ index: Int) {
        self.selectedIndex = index
        
        let cardViewModel = TextCardViewModel()
        cardViewModel.card = self.cardList[index]
        cardViewModel.setView()
        SceneCoordinator.sharedInstance.push(scene: .textCardView(cardViewModel))
    }
    
    func onEditCard() {
        bindActionSheet()
    }
    
    func onEditTextCard() {
        let cardViewModel = TextCardViewModel()
        cardViewModel.card.feedbackID = feedback.id
        cardViewModel.boardViewModel = self
        SceneCoordinator.sharedInstance.push(scene: .editTextCardView(cardViewModel))
    }
    
    private func bindAlert(title: String, text: String) {
        SceneCoordinator.sharedInstance
            .getCurrentViewController()?
            .alert(title: title, text: text)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func bindActionSheet() {
        SceneCoordinator.sharedInstance
            .getCurrentViewController()?.actionSheet(title: "게시물 추가", text: nil, actions: [("글 게시물 추가", onEditTextCard)])
            .subscribe()
            .disposed(by: disposeBag)
        
    }
}

// MARK: CRUD
extension BoardViewModel {
    func fetchList() {
        requestList()
    }
    
    func updateList() {
        cardListOutput.accept(cardList)
    }
    
    func addedCard(_ card: Card) {
        cardList.insert(card, at: 0)
        cardListOutput.accept(cardList)
    }
    
    func modifiedCard(_ card: Card) {
        guard self.selectedIndex != -1 else { return }
        cardList[selectedIndex] = card
        cardListOutput.accept(cardList)
    }
    
    func deleteCard(_ index: Int) {
        requestDeletion(index)
        cardList.remove(at: index)
        cardListOutput.accept(cardList)
    }
}

// MARK: Network
extension BoardViewModel {
    /// 피드백에 대한 게시물 리스트
    func requestList() {
        APIHelper.sharedInstance.rxPullResponse(.getCards(feedback.id, 0))
            .subscribe(onNext: { [weak self] in
                
                guard $0.isSuccess, let dataList = $0.dataDic else {
                    self?.bindAlert(title: "안내", text: $0.msg ?? "알 수 없는 오류가 발생했습니다.")
                    return
                }
                
                self?.cardList = dataList.map { Card($0) }
                self?.cardListOutput.accept(self?.cardList ?? [])
                
            })
            .disposed(by: disposeBag)
    }
    
    func requestDeletion(_ index: Int) {
        APIHelper.sharedInstance.rxPullResponse(.delCard(String(cardList[index].id)))
            .subscribe(onNext: {
                NWLog.sLog(contentName: "게시물 삭제 요청 결과", contents: $0.msg)
            })
            .disposed(by: disposeBag)
    }
    
}
