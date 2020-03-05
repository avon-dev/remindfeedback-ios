//
//  BoardViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/01/21.
//  Copyright © 2020 avon. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import RxViewController
import UIKit

class BoardViewController: UIViewController {
    
    var viewModel: BoardViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: BoardViewModelType = BoardViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = BoardViewModel()
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }

    /// 게시물 추가 버튼
    @IBOutlet weak var addCardBtn: UIButton!
    /// 해당 피드백 타이틀 레이블
    @IBOutlet weak var titleLabel: UILabel!
    /// 피드백 시작일 표시 레이블
    @IBOutlet weak var dateLabel: UILabel!
    /// 텍스트 게시물 정렬 버튼
    @IBOutlet weak var sortTxtBtn: UIButton!
    /// 게시물 리스트
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewModel.updateList()
    }
    
}

// - MARK: UI
extension BoardViewController {
    func setUI() {
        setNavUI()
    }
    
    func setNavUI() {
        // 네비게이션 바 색상 지정
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
}

// - MARK: Binding
extension BoardViewController {
    func setBinding() {
        
        // Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 { self?.viewModel.setScene(self ?? UIViewController()) }
            })
            .disposed(by: self.disposeBag)
        
        // VM to V
        
        // 네비게이션 바 타이틀 설정
        self.viewModel.titleOb
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: self.disposeBag)
        
        // 피드백 제목 설정
        self.viewModel.titleOb
            .subscribe(onNext: { [weak self] in
                self?.titleLabel.text = "[" + $0 + "]의 개선사항"
            })
            .disposed(by: self.disposeBag)
        
        // 피드백 날짜 설정
        self.viewModel.dateOb
            .subscribe(onNext: { [weak self] in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy년 MM월 dd일"
                dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
                
                self?.dateLabel.text = dateFormatter.string(from: $0) + " 시작"
            })
            .disposed(by: self.disposeBag)
        
        // 게시물 리스트
        self.viewModel.reqGetCards()
        self.viewModel.cardListOb
            .bind(to: tableView.rx.items(cellIdentifier: CardCell.identifier, cellType: CardCell.self)) {

                index, item, cell in
                cell.onData.onNext(item)
            }
            .disposed(by: self.disposeBag)
        
        // V to VM
        
        // 테이블 뷰 셀을 선택했을 때
        self.tableView.rx.itemSelected
            .subscribe(onNext: {
                // 해당 게시물에 대한 상세 화면으로 이동
                self.viewModel.onTextCard($0.item)
            })
            .disposed(by: self.disposeBag)
        
        // 테이블 뷰 셀을 좌측으로 스와이프할 때
        self.tableView.rx.itemDeleted
            .subscribe(onNext: {
                // 해당 피드백을 삭제
                self.viewModel.delCard($0.item)
            })
            .disposed(by: self.disposeBag)
        
        // 게시물 추가 버튼을 눌렀을 때
        self.addCardBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.onEditTextCard()
            })
            .disposed(by: self.disposeBag)
    }
}
