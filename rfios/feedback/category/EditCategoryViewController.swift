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
    @IBOutlet weak var colorBtn21: UIButton!
    @IBOutlet weak var colorBtn22: UIButton!
    @IBOutlet weak var colorBtn23: UIButton!
    @IBOutlet weak var colorBtn24: UIButton!
    @IBOutlet weak var colorBtn25: UIButton!
    var selectedBtn: UIButton?

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
        colorHexStringList = ["#E51C23", "#FF5722", "#FFFF00", "#259B24", "#18FFFF", "#3F51B5", "#9C27B0", "#FF4081", "#964B00", "#000000"]
        colorBtnList = [self.colorBtn11, self.colorBtn12, self.colorBtn13, self.colorBtn14, self.colorBtn15, self.colorBtn21, self.colorBtn22, self.colorBtn23, self.colorBtn24, self.colorBtn25]
        
        for i in 0..<colorBtnList.count {
            colorBtnList[i].backgroundColor = UIUtil.hexStringToUIColor(colorHexStringList[i])
            colorBtnList[i].tag = i
        }
        
    }
}


extension EditCategoryViewController {
    
    func setBinding() {
        
        // Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 { self?.viewModel.setScene(self ?? UIViewController()) }
            })
            .disposed(by: self.disposeBag)
        
        // Output
        if let index = self.viewModel.selectedIndex {
            self.viewModel.categoryListOb
                .flatMap{ Observable.of($0[index]) }
                .take(1) // 왜 했더라...
                .subscribe(onNext: { [weak self] in
                    // 화면에 기존 데이터가 보이기 위한 코드
                    self?.titleTxtFld.text = $0.title
                    
                    for (offset,hex) in (self?.colorHexStringList ?? []).enumerated() {
                        if hex == $0.color {
//                            self?.colorBtnList[offset].setImage(.checkmark, for: .normal)
                        }
                    }
                    
                    // 기존의 데이터 중 일부만 수정해도 에러없이 저장할 수 있도록 특정 인스턴스에 기존의 값 저장
                })
                .disposed(by: self.disposeBag)
        }
        
        
        // Input
        
        // 주제 추가 및 수정 취소
        self.xBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
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
                    self?.selectedBtn?.setImage(nil, for: .normal)
                    self?.selectedBtn = nil
                    self?.selectedBtn = btn
//                    btn.setImage(.checkmark, for: .normal)
                    self?.viewModel.colorInput.onNext($0)
                })
                .disposed(by: self.disposeBag)
            
        }
        
    }
    
}
