//
//  CardViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/02/02.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol CardViewModelType: BaseViewModelType {
    // V to VM
    
    // For show
    var titleOb: BehaviorSubject<String> { get }
    var dateOb: BehaviorSubject<Date> { get }
    var titleDateOb: BehaviorSubject<String> { get }
    var contentOb: BehaviorSubject<String> { get }
    
    // For Edit
    /// 제목 텍스트 입력 옵져버블
    var titleInput: BehaviorSubject<String> { get }
    /// 내용 텍스트 입력 옵져버블
    var contentInput: BehaviorSubject<String> { get }
    var isModify: Bool { get }
    
    // Binding
    func setView()
    
    // CRUD
    func addTextCard()
    func modTextCard()
    
    // Network
    func reqAddTextCard()
    func reqModTextCard()
}

class TextCardViewModel: BaseViewModel, CardViewModelType {
    
    let titleOb: BehaviorSubject<String>
    let dateOb: BehaviorSubject<Date>
    let titleDateOb: BehaviorSubject<String>
    let contentOb: BehaviorSubject<String>
    
    let titleInput: BehaviorSubject<String>
    let contentInput: BehaviorSubject<String>
    var isModify = false
    
    /// 현재 View에서 Card를 1개만 제어할 때, 해당 인스턴스를 담아둘 프로퍼티
    var card = Card()
    
    var boardViewModel = BoardViewModel()
    
    override init() {
        self.titleOb = BehaviorSubject<String>(value: "")
        self.dateOb = BehaviorSubject<Date>(value: Date())
        self.titleDateOb = BehaviorSubject<String>(value: "")
        self.contentOb = BehaviorSubject<String>(value: "")
        
        self.titleInput = BehaviorSubject<String>(value: "")
        self.contentInput = BehaviorSubject<String>(value: "")
        
        super.init()
        
        //
        Observable.combineLatest(self.titleOb, self.dateOb, resultSelector: {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            
            return "[글] \($0)\n \(dateFormatter.string(from: $1))"
        })
            .bind(to: self.titleDateOb)
            .disposed(by: self.disposeBag)
        
        // [글] 형태의 card를 추가/수정할 때 필수요소 입력 여부를 확인하는 옵져버블
        Observable.combineLatest(titleInput, contentInput, resultSelector: {
            let _card = self.card
            _card.title = $0
            _card.content = $1
            return _card
        })
            .subscribe(onNext: { [weak self] in
                self?.card = $0
            })
            .disposed(by: self.disposeBag)
    }
    
}

// - MARK: Sence
extension TextCardViewModel {
    func onModCard() {
        self.isModify = true
        SceneCoordinator.sharedInstance.push(scene: .editTextCardView(self))
    }
}

// - MARK: Binding
extension TextCardViewModel {
    func setView() {
        self.titleOb.onNext(self.card.title)
        self.dateOb.onNext(self.card.date)
        self.contentOb.onNext(self.card.content)
    }
}

// - MARK: CRUD
extension TextCardViewModel {
    func addTextCard() {
        SceneCoordinator.sharedInstance.show()
        self.reqAddTextCard()
    }
    
    func modTextCard() {
        SceneCoordinator.sharedInstance.show()
        self.reqModTextCard()
    }
}

// - MARK: Network
extension TextCardViewModel {
    func reqAddTextCard() {
        APIHelper.sharedInstance.rxPullResponse(.addTextCard(self.card.toDictionary()))
            .subscribe(onNext: { [weak self] in
                
                NWLog.sLog(contentName: "card 추가 응답 결과", contents: $0.msg)
                guard let id = $0.data?["id"] as? Int else { return }
                self?.card.id = id
                self?.boardViewModel.addCard(self?.card ?? Card())
                }, onCompleted: {
                    
                    SceneCoordinator.sharedInstance.hide()
                    SceneCoordinator.sharedInstance.pop()
            })
            .disposed(by: self.disposeBag)
    }
    
    func reqModTextCard() {
        APIHelper.sharedInstance.rxPullResponse(.modTextCard(self.card.toDictionary(), id: String(self.card.id)) )
            .subscribe(onNext: { [weak self] in
                
                NWLog.sLog(contentName: "card 수정 응답 결과", contents: $0.msg)
                
                // 이전 게시물 상세 화면에 데이터 업데이트
                self?.titleOb.onNext(self?.card.title ?? "")
                self?.contentOb.onNext(self?.card.content ?? "")
                // 게시물 리스트 화면에 데이터 업데이트
                self?.boardViewModel.modCard(self?.card ?? Card())
                
                }, onCompleted: {
                    
                    SceneCoordinator.sharedInstance.hide()
                    SceneCoordinator.sharedInstance.pop()
            })
            .disposed(by: self.disposeBag)
    }
}


