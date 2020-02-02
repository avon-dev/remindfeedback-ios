//
//  FeedbackCell.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/09.
//  Copyright © 2019 avon. All rights reserved.
//

import RxSwift
import UIKit

class FeedbackCell: UITableViewCell {
    
    static let identifier = "feedbackCell"
    
    private let cellDisposeBag = DisposeBag()
    
    var viewModel: FeedbackViewModelType? = nil
    var disposeBag = DisposeBag()
    let onData: AnyObserver<Feedback>
    
    required init?(coder aDecoder: NSCoder) {
        
        let data = PublishSubject<Feedback>()
        onData = data.asObserver()
        
        super.init(coder: aDecoder)

        data.observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                NWLog.dLog(contentName: "", contents: $0)
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

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    
//    required init?(coder aDecoder: NSCoder) { 
//        super.init(coder: aDecoder)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
