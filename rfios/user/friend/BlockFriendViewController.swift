//
//  BlockFriendViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/03/25.
//  Copyright © 2020 avon. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import RxViewController
import UIKit

class BlockFriendViewController: UIViewController {

    var viewModel: FriendViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: FriendViewModelType = FriendViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = FriendViewModel()
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBinding()
    }

}

// MARK: UI
extension BlockFriendViewController {
    func setUI() {
        
    }
}

// MARK: Binding
extension BlockFriendViewController {
    func setBinding() {
        
    }
}
