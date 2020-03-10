//
//  Scene.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/21.
//  Copyright © 2019 avon. All rights reserved.
//


import UIKit

enum Scene {
    
    // Auth
    case loginView(LoginViewModel)
    case registerView(RegisterViewModel)
    
    // Category
    case categoryView(CategoryViewModel)
    case editCategoryView(CategoryViewModel)
    
    // Feedback
    case editFeedbackView(FeedbackViewModel)
    
    // Board
    case boardView(BoardViewModel)
    case textCardView(TextCardViewModel)
    case editTextCardView(TextCardViewModel)
    
    // Mypage
    case myPageView(MyPageViewModel)
}

extension Scene {
    
    func viewController() -> UIViewController {
        
        let feedbackStoryboard = UIStoryboard(name: "Feedback", bundle: nil)
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let userStoryboard = UIStoryboard(name: "User", bundle: nil)
        
        switch self {
        
        // MARK: Auth
            
            // Login
        case .loginView(let viewModel):
            let viewController = loginStoryboard
                .instantiateViewController(withIdentifier: "loginVC")
                as! LoginViewController
            viewController.viewModel = viewModel
            return viewController
            
            // Register
        case .registerView(let viewModel):
            let viewController = loginStoryboard
                .instantiateViewController(withIdentifier: "registerVC")
                as! RegisterViewController
            viewController.viewModel = viewModel
            return viewController
            
        // MARK: Category
            
            // Category List
        case .categoryView(let viewModel):
            let viewController = feedbackStoryboard
                .instantiateViewController(withIdentifier: "categoryVC")
                as! CategoryListViewController
            viewController.viewModel = viewModel
            return viewController
            
            // Edit category
        case .editCategoryView(let viewModel):
            let viewController = feedbackStoryboard.instantiateViewController(withIdentifier: "editCategoryVC") as! EditCategoryViewController
            viewController.viewModel = viewModel
            return viewController
            
        // MARK: Feedback
            
            // Edit Feedback
        case .editFeedbackView(let viewModel):
            let viewController = feedbackStoryboard
                .instantiateViewController(withIdentifier: "editFeedbackVC")
                as! EditFeedbackViewController
            viewController.viewModel = viewModel
            return viewController
            
        // MARK: Board
            
            // Board(Card List)
        case .boardView(let viewModel):
            let viewController = feedbackStoryboard
                .instantiateViewController(withIdentifier: "boardVC")
                as! BoardViewController
            viewController.viewModel = viewModel
            return viewController
            
            // Text card
        case .textCardView(let viewModel):
            let viewController = feedbackStoryboard
                .instantiateViewController(withIdentifier: "textCardVC")
                as! TextCardViewController
            viewController.viewModel = viewModel
            return viewController
            
            // Edit text card
        case .editTextCardView(let viewModel):
            let viewController = feedbackStoryboard.instantiateViewController(withIdentifier: "editTextCardVC") as! EditTextCardViewController
            viewController.viewModel = viewModel
            return viewController
            
        // MARK: Mypage
            
        case .myPageView(let viewModel):
            let viewController = userStoryboard.instantiateViewController(withIdentifier: "myPageVC") as! MyPageViewController
            viewController.viewModel = viewModel
            return viewController

        }
        
        
        
    }
}
