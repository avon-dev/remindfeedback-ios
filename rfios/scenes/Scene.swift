//
//  Scene.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/21.
//  Copyright © 2019 avon. All rights reserved.
//

import UIKit

enum Scene {
  case registerView(RegisterViewModel)
}

extension Scene {
    func viewController() -> UIViewController {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        
        switch self {
        case .registerView(let viewModel):
          let viewController = loginStoryboard.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
          viewController.viewModel = viewModel 
          return viewController

        }
        
    }
}
