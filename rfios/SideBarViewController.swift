//
//  SideMenuViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/09.
//  Copyright © 2019 avon. All rights reserved.
//

//import Hero
import RxCocoa
import RxGesture
import RxSwift
import RxViewController
import UIKit

class SideBarViewController: UIViewController {
    
    var viewModel: MainViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: MainViewModelType = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = MainViewModel()
        super.init(coder: aDecoder)
    }
    

//    @IBOutlet weak var completedBtn: UIButton!
    
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var mypageBtn: UIButton!
    @IBOutlet weak var friendListBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinding()
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
        
    @IBAction func showMainView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

// - MARK: Binding
extension SideBarViewController {
    
        
    func setBinding() {
        
        // Scene
        categoryBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.sideMenuController?.hideMenu()
                self?.viewModel.onCategory()
            })
            .disposed(by: self.disposeBag)
        
        mypageBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.sideMenuController?.hideMenu()
                
            })
            .disposed(by: self.disposeBag)
        
        
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
    
}
