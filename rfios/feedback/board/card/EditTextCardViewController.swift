//
//  EditTextCardViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/02/02.
//  Copyright © 2020 avon. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import RxViewController
import UIKit

class EditTextCardViewController: UIViewController {

    var viewModel: CardViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: CardViewModelType = CardViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = CardViewModel()
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    @IBOutlet weak var titleTxtFld: UITextField!
    @IBOutlet weak var contentTxtView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBinding()
    }
    

}

// - MARK: UI
extension EditTextCardViewController {
    func setUI() {
        setNavUI()
    }
    
    func setNavUI() {
        // 네비게이션 바 색상 지정
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // 네비게이션 바 타이틀 설정
        self.navigationItem.title = "새로운 카드"
        // 네비게이션 바 우측버튼
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "저장", style: .done, target: self, action: nil)
        
    }
}

// - MARK: Binding
extension EditTextCardViewController {
    func setBinding() {
        // Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 { self?.viewModel.setScene(self ?? UIViewController()) }
            })
            .disposed(by: self.disposeBag)
        
        // Enable to click
        // 추가/수정가능할 때만 저장버튼 활성화
        let titleOb = self.titleTxtFld.rx.text.orEmpty
        let contentOb = self.contentTxtView.rx.text.orEmpty
        
        Observable.combineLatest(titleOb.map { $0.count > 0 }, contentOb.map { $0.count > 0 }, resultSelector: {
                return $0 && $1
            })
            .subscribe(onNext: { [weak self] in
                self?.navigationItem.rightBarButtonItem?.isEnabled = $0
            })
            .disposed(by: self.disposeBag)
        
        // V to Vm
        
        // 제목 옵져버블 바인딩
        titleOb.bind(to: self.viewModel.titleInput).disposed(by: self.disposeBag)
        // 내용 옵져버블 바인딩
        contentOb.bind(to: self.viewModel.contentInput).disposed(by: self.disposeBag)
        
        // 저장버튼 클릭했을 때
        self.navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.reqAddCard()
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
}
