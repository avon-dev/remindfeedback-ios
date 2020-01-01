//
//  EditCategoryViewController.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/12/07.
//  Copyright © 2019 avon. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import RxViewController
import UIKit

class EditCategoryViewController: UIViewController {
    
    var viewModel: CategoryViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: CategoryViewModelType = CategoryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = CategoryViewModel()
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    @IBOutlet weak var xBtn: UIBarButtonItem!
    @IBOutlet weak var completedBtn: UIBarButtonItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTxtFld: UITextField!
    @IBOutlet weak var colorLabel: UILabel!
    
    var colorBtnList: [UIButton] = []
    var colorHexStringList: [String] = []
    @IBOutlet weak var colorBtn11: UIButton!
    @IBOutlet weak var colorBtn12: UIButton!
    @IBOutlet weak var colorBtn13: UIButton!
    @IBOutlet weak var colorBtn14: UIButton!
    @IBOutlet weak var colorBtn15: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let statusBarView = UIApplication.statusBarView else { return }
//        UIApplication.statusBarBackgroundColor = .blue
        setUI()
        setBinding()
        
    }

}

extension EditCategoryViewController {
    func setUI() {
        colorHexStringList = ["#1389FF", "#61D761", "#FF1289", "#052749", "#000000"]
        colorBtnList = [self.colorBtn11, self.colorBtn12, self.colorBtn13, self.colorBtn14, self.colorBtn15]
        
        for i in 0..<colorBtnList.count {
            colorBtnList[i].backgroundColor = UIUtil.hexStringToUIColor(colorHexStringList[i])
            colorBtnList[i].tag = i
        }
        
    }
}


extension EditCategoryViewController {
    
    func setBinding() {
        
        // Output
        if let index = self.viewModel.selectedIndex {
            self.viewModel.categoryListOb
                .flatMap{ Observable.of($0[index]) }
                .take(1)
                .subscribe(onNext: { [weak self] in
                    // 화면에 기존 데이터가 보이기 위한 코드
                    self?.titleTxtFld.text = $0.title
                        // TODO: 컬러 설정 추가 필요
                    
                    // 기존의 데이터 중 일부만 수정해도 에러없이 저장할 수 있도록 특정 인스턴스에 기존의 값 저장
                })
                .disposed(by: self.disposeBag)
        }
        
        
        // Input
        
        // 주제 추가 및 수정 취소
        self.xBtn.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        // 주제 추가 및 수정 완료
        self.completedBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                
                if self?.viewModel.selectedIndex != nil {
                    // 주제 수정
                    self?.viewModel.modCategory()
                } else {
                    // 주제 추가
                    self?.viewModel.addCategory()
                }
                
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        // 주제 제목
        self.titleTxtFld.rx.text.orEmpty
            .bind(to: self.viewModel.titleInput)
            .disposed(by: self.disposeBag)
        
        // 주제 테마 컬러 설정
        for btn in colorBtnList {
            
            btn.rx.tap
                .flatMap{ [weak self] in
                    Observable.of(self?.colorHexStringList[btn.tag] ?? "")
                }
                .subscribe(onNext:{ [weak self] in
                    self?.viewModel.colorInput.onNext($0)
                })
                .disposed(by: self.disposeBag)
            
        }
        
    }
    
}
