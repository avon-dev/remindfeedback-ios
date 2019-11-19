//
//  UIViewController+Extension.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/19.
//  Copyright © 2019 avon. All rights reserved.
//

import UIKit

extension UIViewController {
 
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
}
