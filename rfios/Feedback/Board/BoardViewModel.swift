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
    
    // VM to V
    var titleOb: BehaviorSubject<String> { get }
    var dateOb: BehaviorSubject<Date> { get }
    var cardListOb: BehaviorRelay<[Card]> { get }
    
    // Scene
    func onTextCard(_ index: Int)
    func onEditTextCard()
    
    // CRUD
    func delCard(_ index: Int)
    
    // Network
    func reqGetCards()
    
    
    func updateList()
    
}

class BoardViewModel: BaseViewModel, BoardViewModelType {
    
    var feedback = Feedback()
    let titleOb: BehaviorSubject<String>
    let dateOb: BehaviorSubject<Date>
    
    var cardList = [Card]()
    let cardListOb: BehaviorRelay<[Card]>
    var selectedIndex = -1
    
    override init() {
        self.titleOb = BehaviorSubject.init(value: "")
        self.dateOb = BehaviorSubject.init(value: Date())
        self.cardListOb = BehaviorRelay<[Card]>(value: cardList)
        super.init()
    }
    
}

// - MARK: Scene
extension BoardViewModel {
    /// on 글 형태 게시물
    func onTextCard(_ index: Int) {
        self.selectedIndex = index
        
        let cardViewModel = TextCardViewModel()
        cardViewModel.card = self.cardList[index]
        cardViewModel.setView()
        SceneCoordinator.sharedInstance.push(scene: .textCardView(cardViewModel))
    }
    
    func onEditTextCard() {
        let cardViewModel = TextCardViewModel()
        cardViewModel.card.feedbackID = feedback.id
        cardViewModel.boardViewModel = self
        SceneCoordinator.sharedInstance.push(scene: .editTextCardView(cardViewModel))
    }
}

extension BoardViewModel {
    func delCard(_ index: Int) {
        NWLog.sLog(contentName: "게시물 삭제", contents: nil)
        self.reqDelCard(index)
        self.cardList.remove(at: index)
        self.cardListOb.accept(self.cardList)
    }
}

// - MARK: Network
extension BoardViewModel {
    /// 피드백에 대한 게시물 리스트
    func reqGetCards() {
        APIHelper.sharedInstance.rxPullResponse(.getCards(self.feedback.id, 0))
            .subscribe(onNext: { [weak self] in
                guard let dataList = $0.dataDic else { return }
                
                for data in dataList {
                    let card = Card()
                    card.id = data["id"] as? Int ?? -1
                    card.category = data["board_category"] as? Int ?? -1
                    card.title = data["board_title"] as? String ?? ""
                    card.content = data["board_content"] as? String ?? ""
                    card.feedbackID = data["fk_feedbackId"] as? Int ?? -1
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
                    
                    let dateStr: String = data["createdAt"] as? String ?? ""
                    card.date = dateFormatter.date(from: dateStr) ?? Date()
                    
                    /**
                     TODO
                     board_file1=[string] 1번째 사진파일, 영상, 녹음파일
                     board_file2=[string] (사진게시물) 2번째 사진파일
                     board_file3=[string] (사진게시물) 3번째 사진파일
                     confirm=[boolean] 게시물 확인 여부
                     */
                    
                    self?.cardList.append(card)
                }
                
                self?.cardListOb.accept(self?.cardList ?? [])
                
            })
            .disposed(by: self.disposeBag)
    }
    
    //
    func reqDelCard(_ index: Int) {
        APIHelper.sharedInstance.rxPullResponse(.delCard(String(self.cardList[index].id)))
            .subscribe(onNext: {
                NWLog.sLog(contentName: "게시물 삭제 요청 결과", contents: $0.msg)
            })
            .disposed(by: self.disposeBag)
    }
    
   
}

//
extension BoardViewModel {
    func addCard(_ card: Card) {
        self.cardList.insert(card, at: 0)
        updateList()
    }
    
    func modCard(_ card: Card) {
        guard self.selectedIndex != -1 else { return }
        self.cardList[self.selectedIndex] = card
        updateList()
    }
    
    func updateList() {
        self.cardListOb.accept(self.cardList)
    }
}
