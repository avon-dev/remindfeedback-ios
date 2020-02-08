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
    
    /// 제목 텍스트 입력 옵져버블
    var titleInput: BehaviorSubject<String> { get }
    /// 내용 텍스트 입력 옵져버블
    var contentInput: BehaviorSubject<String> { get }
    
    // Network
    func reqAddCard()
}

class CardViewModel: BaseViewModel, CardViewModelType {
    
    let titleInput: BehaviorSubject<String>
    let contentInput: BehaviorSubject<String>
    
    /// 현재 View에서 Card를 1개만 제어할 때, 해당 인스턴스를 담아둘 프로퍼티
    var card = Card()
    
    override init() {
        self.titleInput = BehaviorSubject<String>(value: "")
        self.contentInput = BehaviorSubject<String>(value: "")
        
        super.init()
        
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

// -MARK : Network
extension CardViewModel {
    func reqAddCard() {
        APIHelper.sharedInstance.rxPullResponse(.addTextCard(self.card.toDictionary()))
            .subscribe(onNext: {
                NWLog.sLog(contentName: "card 추가 응답 결과", contents: $0.msg)
            })
            .disposed(by: self.disposeBag)
    }
}
