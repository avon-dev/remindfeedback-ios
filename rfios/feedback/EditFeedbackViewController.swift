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
    @IBOutlet weak var categoryColor: UIView! // 피드백 주제 컬러를 표시하는 이미지뷰
    @IBOutlet weak var categoryTitle: UILabel! // 피드백 주제 이름을 표시하는 이미지뷰
    @IBOutlet weak var categoryBtn: UIButton! // 피드백 주제를 선택할 수 있게 하는 버튼
    @IBOutlet weak var titleTxtFld: UITextField! // 피드백 제목을 입력하는 버튼
    @IBOutlet weak var dateLabel: UILabel! // 피드백 날짜가 표시되는 레이블
    @IBOutlet weak var dateBtn: UIButton! // 피드백 날짜를 선택할 수 있게 하는 버튼
    @IBOutlet weak var friendBtn: UIButton! // 피드백 조언자를 선택할 수 있게 하는 버튼
    
    // 추가사항. 피드백 날짜를 datepicker형태로 변경
    @IBOutlet weak var datePicker: UIDatePicker! // 피드백 날짜를 선택하고 표시하는 뷰
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.titleTextview.delegate = self
        self.setUI()
        self.setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewModel.setFeedback()
    }

}

// - MARK: UI
extension EditFeedbackViewController {
    
    func setUI() {
//        self.titleTextview.textContainer.maximumNumberOfLines = 2
//        self.titleTextview.textContainer.lineBreakMode = .byTruncatingTail
        self.setNavUI()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"    // date format
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        self.dateLabel.text = dateFormatter.string(from: Date())
        
    }
    
    func setNavUI() {
        
        self.navigationController?.navigationBar.topItem?.title = ""
        // 네비게이션 바 타이틀 설정
        self.navigationItem.title = "새로운 피드백" // -TODO: 추후 해당 리터럴값을 뷰 모델에서 가져올 수 있도록 수정 필요
        // 네비게이션 바 색상 지정
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // 네비게이션 바 우측버튼
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "저장", style: .done, target: self, action: nil)
    }
    
}

// MARK: Binding
extension EditFeedbackViewController {
    func setBinding() {
        
        // MARK: Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 { self?.viewModel.setScene(self ?? UIViewController()) }
            })
            .disposed(by: self.disposeBag)
        
        // MARK: Output
        /// 피드백 주제 선택
        self.categoryBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.onCategory()
            })
            .disposed(by: self.disposeBag)
        
        // 피드백 제목 입력
        self.titleTxtFld.rx.text.orEmpty
            .bind(to: self.viewModel.titleInput)
            .disposed(by: self.disposeBag)
        
        // 피드백 날짜 선택
        self.datePicker.rx.value // value대산에 date를 사용해도 되는듯
            .bind(to: self.viewModel.dateInput)
            .disposed(by: self.disposeBag)
        
        
        // 피드백 조언자 선택
        // - TODO: 친구기능 완성 후
        
        // 피드백 추가
        self.navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: {
                self.viewModel.reqAddFeedback()
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        
        // MARK: Input
        ///
        self.viewModel.categoryOb
            .skip(1) // 디폴트값 걷어내기
            .subscribe(onNext: { [weak self] in
                print($0.title)
                self?.categoryColor.backgroundColor = UIUtil.hexStringToUIColor($0.color)
                self?.categoryTitle.text = $0.title
            })
            .disposed(by: self.disposeBag)
        
        ///
        self.viewModel.feedbackOb
            .subscribe(onNext: { [weak self] in
                self?.titleTxtFld.text = $0.title
            })
            .disposed(by: self.disposeBag)
            
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
