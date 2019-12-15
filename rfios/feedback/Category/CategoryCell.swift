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
    
    var disposeBag = DisposeBag()
    let onData: AnyObserver<Category>
    
    required init?(coder aDecoder: NSCoder) {
        
        let data = PublishSubject<Category>()
        onData = data.asObserver()

        super.init(coder: aDecoder)

        data.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                
                self?.titleLabel.text = $0.title
                self?.colorView.backgroundColor = ColorUtil.hexStringToUIColor($0.color)
            })
            .disposed(by: cellDisposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.colorView.backgroundColor = ColorUtil.hexStringToUIColor("#000000")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


