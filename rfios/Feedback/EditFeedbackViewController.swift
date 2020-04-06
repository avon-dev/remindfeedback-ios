//
//  EditFeedbackViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/10.
//  Copyright © 2019 avon. All rights reserved.
//

import Kingfisher
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
    
    @IBOutlet weak var categoryColor: UIView! // 피드백 주제 컬러를 표시하는 이미지뷰
    @IBOutlet weak var categoryTitle: UILabel! // 피드백 주제 이름을 표시하는 이미지뷰
    @IBOutlet weak var categoryBtn: UIButton! // 피드백 주제를 선택할 수 있게 하는 버튼
    @IBOutlet weak var titleField: UITextField! // 피드백 제목을 입력하는 버튼
    @IBOutlet weak var dateLabel: UILabel! // 피드백 날짜가 표시되는 레이블
    @IBOutlet weak var dateBtn: UIButton! // 피드백 날짜를 선택할 수 있게 하는 버튼
    @IBOutlet weak var adviserBtn: UIButton! // 피드백 조언자를 선택할 수 있게 하는 버튼
     
    @IBOutlet weak var adviserPortrait: UIImageView!
    @IBOutlet weak var adviserNickname: UILabel!
    
    // 추가사항. 피드백 날짜를 datepicker형태로 변경
    @IBOutlet weak var datePicker: UIDatePicker! // 피드백 날짜를 선택하고 표시하는 뷰
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.titleTextview.delegate = self
        setUI()
        setBinding()
    }

}

// - MARK: UI
extension EditFeedbackViewController {
    
    func setUI() {
//        self.titleTextview.textContainer.maximumNumberOfLines = 2
//        self.titleTextview.textContainer.lineBreakMode = .byTruncatingTail
        setNavUI()
        adviserPortrait.layer.cornerRadius = adviserPortrait.frame.height / 2
        adviserPortrait.clipsToBounds = true
    }
    
    func setNavUI() {
        self.navigationController?.navigationBar.topItem?.title = ""
        // 네비게이션 바 색상 지정
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // 네비게이션 바 우측버튼
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "저장", style: .done, target: self, action: nil)
    }
    
    func updateUI() {
        // 네비게이션 바 타이틀 설정
        self.navigationItem.title = "피드백 설정" // -TODO: 추후 해당 리터럴값을 뷰 모델에서 가져올 수 있도록 수정 필요
    }
    
}

// MARK: Binding
extension EditFeedbackViewController {
    func setBinding() {
        
        // MARK: Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.viewModel.setScene(self ?? UIViewController())
                    self?.updateUI()
                }
            }).disposed(by: disposeBag)
        
        // MARK: Output
        /// 피드백 주제 선택
        categoryBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.onCategory()
            }).disposed(by: disposeBag)
        
        // 피드백 제목 입력
        titleField.rx.text.orEmpty
            .bind(to: viewModel.titleInput)
            .disposed(by: disposeBag)
        
        // 피드백 날짜 선택
        datePicker.rx.date // value대산에 date를 사용해도 되는듯
            .filter { !Calendar.current.isDateInToday($0) } // 기존 피드백의 날짜 데이터가 오늘 날짜로 덮어씌어지는 경우가 있기에 추가
            .bind(to: viewModel.dateInput)
            .disposed(by: disposeBag)
        
        
        // 피드백 조언자 선택
        adviserBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.onAdviser()
            }).disposed(by: disposeBag)
        
        // 피드백 추가 및 수정
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.doneEdition()
            }).disposed(by: disposeBag)
        
        // MARK: Input
        viewModel.colorOutput
            .asDriver()
            .drive(categoryColor.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.categoryTitleOutput
            .asDriver()
            .drive(categoryTitle.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.feedbackTitleOutput
            .asDriver()
            .drive(titleField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dateOutput
            .asDriver()
            .drive(datePicker.rx.date)
            .disposed(by: disposeBag)
        
        viewModel.adviserOutput
            .subscribe(onNext: { [weak self] in
                
                guard !$0.uid.isEmpty else {
                    self?.adviserPortrait.image = UIImage(named: "plus-main")
                    self?.adviserNickname.text = "조언자 추가하기"
                    self?.adviserNickname.textAlignment = .center
                    return
                }
                
                let url = URL(string: RemindFeedback.imgURL + $0.portrait)!
                self?.adviserPortrait.kf.setImage(with: url, placeholder: UIImage(named: "user-black"))
                self?.adviserNickname.text = $0.nickname
                self?.adviserNickname.textAlignment = .natural
            }).disposed(by: disposeBag)
            
    }
}

// MARK: LEGACY

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
