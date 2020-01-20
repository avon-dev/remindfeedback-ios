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

    private let cellDisposeBag = DisposeBag()
    
    var viewModel: CategoryViewModelType? = nil
    var disposeBag = DisposeBag()
    let onData: AnyObserver<Category>
    
    required init?(coder aDecoder: NSCoder) {
        
        let data = PublishSubject<Category>()
        onData = data.asObserver()
        
        super.init(coder: aDecoder)

        data.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.titleLabel.text = $0.title
                NWLog.sLog(contentName: "헥스스트링 디버그", contents: $0.color)
                self?.colorView.backgroundColor = UIUtil.hexStringToUIColor($0.color)
                self?.setBindings()
            })
            .disposed(by: cellDisposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    deinit {
        self.disposeBag = DisposeBag()
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
        self.modifyBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                print("on주제 수정")
                self?.viewModel?.onModify(self?.index ?? -1)
            })
            .disposed(by: self.disposeBag)
    }

}


