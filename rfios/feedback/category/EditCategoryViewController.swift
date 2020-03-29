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
    @IBOutlet weak var titleField: UITextField!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
    }

}

// MARK: UI
extension EditCategoryViewController {
    func setUI() {
        setNavUI()
        
        colorHexStringList = ["#E51C23", "#FF5722", "#FFFF00", "#259B24", "#18FFFF", "#3F51B5", "#9C27B0", "#FF4081", "#964B00", "#000000"]
        colorBtnList = [self.colorBtn11, self.colorBtn12, self.colorBtn13, self.colorBtn14, self.colorBtn15, self.colorBtn21, self.colorBtn22, self.colorBtn23, self.colorBtn24, self.colorBtn25]
        
        for i in 0..<colorBtnList.count {
            colorBtnList[i].backgroundColor = UIUtil.hexStringToUIColor(colorHexStringList[i])
            colorBtnList[i].tag = i
        }
        
    }
    
    func setNavUI() {
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: nil)
    }
    
    func updateUI() {
        self.navigationItem.title = "피드백 주제 설정"
    }
}

// MARK: Binding
extension EditCategoryViewController {
    
    func setBinding() {
        
        // MARK: Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 { self?.viewModel.setScene(self ?? UIViewController()) }
            })
            .disposed(by: self.disposeBag)
        
        // MARK: Input
        if let index = viewModel.selectedIndex {
            viewModel.categoryListOutput
                .flatMap{ Observable.of($0[index]) }
                .take(1) // 왜 했더라...
                .subscribe(onNext: { [weak self] in
                    // 화면에 기존 데이터가 보이기 위한 코드
                    self?.titleField.text = $0.title
                    
                    for (offset,hex) in (self?.colorHexStringList ?? []).enumerated() {
                        if hex == $0.color {
                            self?.selectedBtn = self?.colorBtnList[offset]
                            self?.colorBtnList[offset].setImage(UIImage(named: "check-mark-white"), for: .normal)
                        }
                    }
                })
                .disposed(by: self.disposeBag)
        }
        
        
        // MARK: Output
        
        // 주제 추가 및 수정 완료
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                if self?.viewModel.selectedIndex != nil {
                    // 주제 수정
                    self?.viewModel.modify()
                } else {
                    // 주제 추가
                    self?.viewModel.add()
                }
            })
            .disposed(by: self.disposeBag)
        
        // 주제 제목
        titleField.rx.text.orEmpty
            .bind(to: self.viewModel.titleInput)
            .disposed(by: self.disposeBag)
        
        // 주제 테마 컬러 설정
        for btn in colorBtnList {
            
            btn.rx.tap
                .flatMap { [weak self] in
                    Observable.of(self?.colorHexStringList[btn.tag] ?? "")
                }
                .subscribe(onNext:{ [weak self] in
                    self?.selectedBtn?.setImage(nil, for: .normal)
                    self?.selectedBtn = nil
                    self?.selectedBtn = btn
                    self?.selectedBtn?.setImage(UIImage(named: "check-mark-white"), for: .normal)
                    self?.viewModel.colorInput.onNext($0)
                })
                .disposed(by: self.disposeBag)
        }
        
    }
    
}
