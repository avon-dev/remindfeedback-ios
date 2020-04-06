//
//  SceneCoordinator.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/21.
//  Copyright © 2019 avon. All rights reserved.
//

import UIKit

class SceneCoordinator { 
    
    fileprivate var currentViewController: UIViewController?
    
    static let sharedInstance = SceneCoordinator()
    
    required init() {
        currentViewController = nil
    }
    
    /// 현재 Scene으로 등록되어 있는 뷰컨트롤러가 있는지 확인하는 함수
    func hasCurrentViewController() -> Bool {
        return self.currentViewController == nil
    }
    
    /// 현재 화면의 반환하는 함수
    func getCurrentViewController() -> UIViewController? {
        return currentViewController
    }
    
    /// 현재 화면을 등록하는 함수
    func setCurrentViewController(_ viewController: UIViewController?) {
        currentViewController = viewController
    }
    
    // MARK: Indicator
    
    func show() {
        self.currentViewController?.showSpinner(onView: self.currentViewController?.view ?? UIView())
    }
    
    func hide() {
        self.currentViewController?.hideSpinner()
    }
    
    // MARK: Transition
    
    func pop() {
        if let navigationController = currentViewController?.navigationController {
            
            navigationController.popViewController(animated: true)
            
            if let lastViewController = navigationController.viewControllers.last {
                setCurrentViewController(lastViewController)
            }
        }
    }
    
    func push(scene: Scene) {
        let nextViewController = scene.viewController()
        
        guard nextViewController != currentViewController else { return }
        
        currentViewController?.navigationController?
            .pushViewController(nextViewController, animated: true)
        setCurrentViewController(nextViewController)
    }
    
    
    func present(scene: Scene) {
        let viewController = scene.viewController()
        viewController.modalPresentationStyle = .fullScreen
        self.currentViewController?.present(viewController, animated: true, completion: nil)
        SceneCoordinator.sharedInstance.setCurrentViewController(viewController)
    }
    
}
