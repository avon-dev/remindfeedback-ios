//
//  CategoryCell.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/12/07.
//  Copyright © 2019 avon. All rights reserved.
//

import RxSwift
import UIKit

class CategoryCell: UITableViewCell {
    
    static let identifier = "categoryCell"
    private var cellDisposeBag = DisposeBag()
    
    var viewModel: CategoryViewModelType? = nil
    var disposeBag = DisposeBag()
//    let dataInput: AnyObserver<Category>
    let dataInput: PublishSubject<Category>
    
    required init?(coder aDecoder: NSCoder) {
        
//        let data = PublishSubject<Category>()
        dataInput = PublishSubject<Category>()
        
        super.init(coder: aDecoder)

        dataInput.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.titleLabel.text = $0.title
                if $0.color == "" {
                    self?.colorView.backgroundColor = UIUtil.hexStringToUIColor("#000000")
                } else {
                    self?.colorView.backgroundColor = UIUtil.hexStringToUIColor($0.color)
                }
                self?.setBindings()
            })
            .disposed(by: cellDisposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // 아래의 코드를 지우니 셀 내용이 수정이 됨... 추후 원인 규명 필요
        disposeBag = DisposeBag()
    }
    
    deinit {
        cellDisposeBag = DisposeBag()
        disposeBag = DisposeBag()
    }
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var modifyBtn: UIButton!
    var index: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.colorView.backgroundColor = UIUtil.hexStringToUIColor("#000000")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.viewModel?.selectedIndex = self.index
    }
    
    func setBindings() {
        modifyBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                
                guard let index = self?.index else { return }
                
                if index > 0 {
                    self?.viewModel?.onModify(index)
                } else if index == 0 {
                    self?.bindAlert()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindAlert() {
        SceneCoordinator.sharedInstance
            .getCurrentViewController()?
            .alert(title: "안내", text: "기본 주제는 변경할 수 없습니다.")
            .subscribe()
            .disposed(by: disposeBag)
    }

}


