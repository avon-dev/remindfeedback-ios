//
//  EditFeedbackViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/10.
//  Copyright © 2019 avon. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class EditFeedbackViewController: UIViewController {
    
    var viewModel: FeedbackViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: FeedbackViewModelType = FeedbackViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = FeedbackViewModel()
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
//    @IBOutlet weak var titleTextview: UITextView!
    @IBOutlet weak var categoryBtn: UIButton! // 피드백 주제를 선택할 수 있게 하는 버튼
    @IBOutlet weak var titleTxtFld: UITextField! // 피드백 제목을 입력하는 버튼
    @IBOutlet weak var dateBtn: UIButton! // 피드백 날짜를 선택할 수 있게 하는 버튼
    @IBOutlet weak var friendBtn: UIButton! // 피드백 조언자를 선택할 수 있게 하는 버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.titleTextview.delegate = self
        self.setUI()
    }

}

// - MARK: UI
extension EditFeedbackViewController {
    
    func setUI() {
//        self.titleTextview.textContainer.maximumNumberOfLines = 2
//        self.titleTextview.textContainer.lineBreakMode = .byTruncatingTail
        self.setNavUI()
        
    }
    
    func setNavUI() {
        // 네비게이션 바 타이틀 설정
        self.navigationItem.title = "새로운 피드백" // -TODO: 추후 해당 리터럴값을 뷰 모델에서 가져올 수 있도록 수정 필요
        // 네비게이션 바 색상 지정
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // 네비게이션 바 우측버튼
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: nil)
    }
    
}

// - MARK: Binding
extension EditFeedbackViewController {
    func setBinding() {
        
        // 피드백 주제 선택
        self.categoryBtn.rx.tap
            .subscribe(onNext: {
                
            })
            .disposed(by: self.disposeBag)
        
        // 피드백 제목 입력
        self.titleTxtFld.rx.text.orEmpty
        
        
        // 피드백 날짜 선택
        self.dateBtn.rx.tap
            .subscribe(onNext: {
                
            })
            .disposed(by: self.disposeBag)
        
        // 피드백 조언자 선택
        // - TODO: 친구기능 완성 후
            
    }
}








// - MARK: LEGACY

// - MARK: TextView Option
extension EditFeedbackViewController: UITextViewDelegate {
    
    
    // TextView의 글자 수 제한을 위한 함수
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // 피드백 주제 글자 수 제한
//        if textView == self.titleTextview {
//            guard let str = textView.text else { return true }
//            let newLength = str.count + text.count - range.length
//            return newLength <= 20 // 20자 제한
//        }
        
        return true
    }
    
}
