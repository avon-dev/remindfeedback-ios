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
    var navTitleOb: BehaviorSubject<String> { get }
    
    // Scene
    func onEditTextCard()
}

class BoardViewModel: BaseViewModel, BoardViewModelType {
    
    var feedback = Feedback()
    let navTitleOb: BehaviorSubject<String>
    
    override init() {
        self.navTitleOb = BehaviorSubject.init(value: "")
        super.init()
    }
    
}

// - MARK: Scene
extension BoardViewModel {
    /// on 글 형태 게시물
    func onEditTextCard() {
        let cardViewModel = CardViewModel()
        cardViewModel.card.feedbackID = feedback.id
        SceneCoordinator.sharedInstance.showEditTextCardView(cardViewModel)
    }
}
