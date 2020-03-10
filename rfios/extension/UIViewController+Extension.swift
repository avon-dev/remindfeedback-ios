//
//  UIViewController+Extension.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/19.
//  Copyright © 2019 avon. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
 
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func setSence() {
        SceneCoordinator.sharedInstance.setCurrentViewController(self)
    }
    
}

var vSpinner : UIView?
 
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

// MARK: Alert + rx
extension UIViewController {
    func alert(title: String, text: String?) -> Completable {
        return Completable.create { [weak self] completable in
            
            let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in
                completable(.completed)
            }))
            
            self?.present(alertVC, animated: true, completion: nil)
            
            return Disposables.create {
                alertVC.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func actionSheet(title: String, text: String?) -> Completable {
        return Completable.create { [weak self] completable in
            
            let alertVC = UIAlertController(title: title, message: text, preferredStyle: .actionSheet)
            alertVC.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in
                completable(.completed)
            }))
            
            self?.present(alertVC, animated: true, completion: nil)
            
            return Disposables.create {
                alertVC.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension UIViewController {
    func keyboardHeight() -> Observable<CGFloat> {
        return Observable
            .from([
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                    .map { notification -> CGFloat in
                        (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                },
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                    .map { _ -> CGFloat in
                        0
                }
            ])
            .merge()
    }
}
