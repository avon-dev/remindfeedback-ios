//
//  SceneCoordinator.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/21.
//  Copyright © 2019 avon. All rights reserved.
//

import UIKit

class SceneCoordinator: SceneCoordinatorType { 
    
    fileprivate var currentViewController: UIViewController?
    
    static let sharedInstance = SceneCoordinator()
    
    required init() {
      currentViewController = nil
    }
    
    func setCurrnentViewController(_ viewController: UIViewController?) {
        currentViewController = viewController
    }
    
    func present(_ viewController: UIViewController) {
        self.currentViewController?.present(viewController, animated: false, completion: nil)
    }
    
    func showRegisterView(_ registerViewModel: RegisterViewModel) {
        
        self.present(Scene.registerView(registerViewModel).viewController())
    }
}
