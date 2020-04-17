//
//  CardTableViewCell.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/02/08.
//  Copyright © 2020 avon. All rights reserved.
//

import RxSwift
import UIKit

class CardCell: UITableViewCell {
    
    static let identifier = "cardCell"
    
    private var cellDisposeBag = DisposeBag()
    
    var viewModel: BoardViewModelType? = nil
    let onData: AnyObserver<Card>
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        
        let data = PublishSubject<Card>()
        onData = data.asObserver()
        
        super.init(coder: aDecoder)

        data.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                
                
                self?.icon.image = UIImage(named: "txt-large")
                self?.title.text = $0.title
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy월 MM월 dd일"    // date format
                dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
                self?.date.text = dateFormatter.string(from: $0.date)
                
            })
            .disposed(by: cellDisposeBag)
    }
    
    deinit {
        cellDisposeBag = DisposeBag()
    }
}
