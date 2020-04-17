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
    
}

// MARK: UI
extension BoardViewController {
    func setUI() {
        setNavUI()
    }
    
    func setNavUI() {
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.rightBarButtonItem =
            UIBarButtonItem.init(title: "추가", style: .done, target: self, action: nil)
    }
}

// MARK: Binding
extension BoardViewController {
    func setBinding() {
        
        // MARK: Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.viewModel.setScene(self ?? UIViewController())
                    self?.viewModel.updateList()
                }
            }).disposed(by: disposeBag)
        
        // MARK: Output
        
        // 테이블 뷰 셀을 선택했을 때
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] in
                // 해당 게시물에 대한 상세 화면으로 이동
                self?.viewModel.onTextCard($0.item)
            }).disposed(by: disposeBag)
        
        // 테이블 뷰 셀을 좌측으로 스와이프할 때
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] in
                // 해당 피드백을 삭제
                self?.viewModel.deleteCard($0.item)
            }).disposed(by: disposeBag)
        
        // 게시물 추가 버튼을 눌렀을 때
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.onEditCard()
            }).disposed(by: disposeBag)
        
        // MARK: Input
        
        // 네비게이션 바 타이틀 설정
        viewModel.titleOutput
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        // 피드백 제목 설정
        viewModel.titleOutput
            .map { "[" + $0 + "]의 개선사항" }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 피드백 날짜 설정
        viewModel.dateOutput
            .map {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy년 MM월 dd일"
                dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
                
                return dateFormatter.string(from: $0) + " 시작"
            }.bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 게시물 리스트
        viewModel.fetchList()
        viewModel.cardListOutput
            .bind(to: tableView.rx.items(cellIdentifier: CardCell.identifier, cellType: CardCell.self)) {
                
                index, item, cell in
                cell.onData.onNext(item)
        }.disposed(by: disposeBag)
        
        
    }
}
