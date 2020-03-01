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
    
    private let cellDisposeBag = DisposeBag()
    
    var viewModel: BoardViewModelType? = nil
    var disposeBag = DisposeBag()
    let onData: AnyObserver<Card>
    
    required init?(coder aDecoder: NSCoder) {
        
        let data = PublishSubject<Card>()
        onData = data.asObserver()
        
        super.init(coder: aDecoder)

        data.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                
//                self?.icon.image = UIImage(systemName: "doc.text")
                self?.title.text = $0.title
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy월 MM월 dd일"    // date format
                dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
                self?.date.text = dateFormatter.string(from: $0.date)
                
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
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
