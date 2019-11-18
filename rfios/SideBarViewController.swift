//
//  SideMenuViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/09.
//  Copyright © 2019 avon. All rights reserved.
//

import Hero
import RxCocoa
import RxGesture
import RxSwift
import UIKit

class SideBarViewController: UIViewController {
    
    var disposeBag = DisposeBag()

//    @IBOutlet weak var completedBtn: UIButton!
    
    @IBOutlet weak var friendListBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBinding()
    }
    
    func setBinding() {
//        completedBtn.rx.tapGesture()
//            .when(.recognized)
//            .subscribe(onNext: { _ in
//                self.sideMenuController?.hideMenu()
//
//                let vc = UIStoryboard(name: "Feedback", bundle: nil)
//                    .instantiateViewController(withIdentifier: "completedVC")
//
//                self.present(vc, animated: false, completion: nil)
//
//            })
//            .disposed(by: disposeBag)
        
        friendListBtn.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                
//                let transition = CATransition()
//                transition.duration = 0.2
//                transition.type = CATransitionType.push
//                transition.subtype = CATransitionSubtype.fromRight
//                self.view.window!.layer.add(transition, forKey: kCATransition)
                
                self.sideMenuController?.hideMenu()
                
                let viewController = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "friendListVC")
                
//                viewController.hero.modalAnimationType = .slide(direction: .left)
//                self.hero.replaceViewController(with: viewController)
                
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: false, completion: nil)
                
                
            })
            .disposed(by: disposeBag)
        
    }
    
    @IBAction func showMainView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
