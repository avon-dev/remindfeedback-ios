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
    
    fileprivate var sceneArray: [UIViewController]
    
    static let sharedInstance = SceneCoordinator()
    
    required init() {
        currentViewController = nil
        sceneArray = []
    }
    
    // - MARK: 현재 화면 관련 함수
    
    // 현재 Scene으로 등록되어 있는 뷰컨트롤러가 있는지 확인하는 함수
    func hasCurrentViewController() -> Bool {
        return self.currentViewController == nil
    }
    
    // 현재 화면의 반환하는 함수
    func getCurrentViewController() -> UIViewController? {
        return currentViewController
    }
    
    // 현재 화면을 등록하는 함수
    func setCurrentViewController(_ viewController: UIViewController?) {
        currentViewController = viewController
    }
    
    // - MARK: 화면 이동 관련 함수
    
    //
    func present(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        self.currentViewController?.present(viewController, animated: true, completion: nil)
        SceneCoordinator.sharedInstance.setCurrentViewController(viewController)
    }
    
    // 회원가입 화면으로 이동
    func showRegisterView(_ registerViewModel: RegisterViewModel) {
        self.present(Scene.registerView(registerViewModel).viewController())
    }
    
    // 카테고리 리스트 화면으로 이동
    func showCategoryView(_ categoryViewModel: CategoryViewModel) {
        self.currentViewController?.navigationController?
            .pushViewController(Scene.categoryView(categoryViewModel).viewController(), animated: true)
        SceneCoordinator.sharedInstance.setCurrentViewController(self.currentViewController)
    }
    
    // 카테고리 편집 화면으로 이동
    func showEditCategoryView(_ categoryViewModel: CategoryViewModel) {
        self.present(Scene.editCategoryView(categoryViewModel).viewController())
    }
    
}
