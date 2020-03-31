//
//  BaseViewModel.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/12/02.
//  Copyright © 2019 avon. All rights reserved.
//

import RxSwift
import UIKit

protocol BaseViewModelType {
    func setScene(_ viewController: UIViewController)
}

class BaseViewModel: BaseViewModelType {
    
    var disposeBag = DisposeBag()
    
    init() {
        
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    // Set Scene
    func setScene(_ viewController: UIViewController) {
        NWLog.sLog(contentName: "Current Scene", contents: viewController.title)
        
        if SceneCoordinator.sharedInstance.getCurrentViewController() != viewController {
            SceneCoordinator.sharedInstance.setCurrentViewController(viewController)
        }
    }
}
