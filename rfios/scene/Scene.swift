//
//  Scene.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/21.
//  Copyright © 2019 avon. All rights reserved.
//


import UIKit

enum Scene {
    case loginView(LoginViewModel)
    case registerView(RegisterViewModel)
    
    case categoryView(CategoryViewModel)
    case editCategoryView(CategoryViewModel)
    
    case editFeedbackView(FeedbackViewModel)
    case boardView(BoardViewModel)
    case textCardView(CardViewModel)
    case editTextCardView(CardViewModel)
}

extension Scene {
    func viewController() -> UIViewController {
        
        let feedbackStoryboard = UIStoryboard(name: "Feedback", bundle: nil)
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        
        switch self {
        
        // auth
        case .loginView(let viewModel):
            let viewController = loginStoryboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            viewController.viewModel = viewModel
            return viewController
        case .registerView(let viewModel):
            let viewController = loginStoryboard.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
            viewController.viewModel = viewModel
            return viewController
            
        // category
        case .categoryView(let viewModel):
            let viewController = feedbackStoryboard.instantiateViewController(withIdentifier: "categoryVC") as! CategoryListViewController
            viewController.viewModel = viewModel
            return viewController
        case .editCategoryView(let viewModel):
            let viewController = feedbackStoryboard.instantiateViewController(withIdentifier: "editCategoryVC") as! EditCategoryViewController
            viewController.viewModel = viewModel
            return viewController
            
        // feedback
        case .editFeedbackView(let viewModel):
            let viewController = feedbackStoryboard.instantiateViewController(withIdentifier: "editFeedbackVC") as! EditFeedbackViewController
            viewController.viewModel = viewModel
            return viewController
            
        // board
        case .boardView(let viewModel):
            let viewController = feedbackStoryboard.instantiateViewController(withIdentifier: "boardVC") as! BoardViewController
            viewController.viewModel = viewModel
            return viewController
        case .textCardView(let viewModel):
            let viewController = feedbackStoryboard.instantiateViewController(withIdentifier: "textCardVC") as! TextCardViewController
            viewController.viewModel = viewModel
            return viewController
        case .editTextCardView(let viewModel):
            let viewController = feedbackStoryboard.instantiateViewController(withIdentifier: "editTextCardVC") as! EditTextCardViewController
            viewController.viewModel = viewModel
            return viewController

        }
        
        
        
    }
}
