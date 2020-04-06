//
//  FeedbackCell.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/09.
//  Copyright © 2019 avon. All rights reserved.
//

import Kingfisher
import RxSwift
import UIKit

class FeedbackCell: UITableViewCell {
    
    static let identifier = "feedbackCell"
    private var cellDisposeBag = DisposeBag()
    
    var viewModel: MainViewModelType? = nil
    var disposeBag = DisposeBag()
    let dataInput: PublishSubject<Feedback>
    
    required init?(coder aDecoder: NSCoder) {
        dataInput = PublishSubject<Feedback>()
        super.init(coder: aDecoder)
        setBinding()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    deinit {
        cellDisposeBag = DisposeBag()
        disposeBag = DisposeBag()
    }

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var adviserImage: UIImageView!
    var index = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
}

// MARK: UI
extension FeedbackCell {
    func setUI() {
        adviserImage.layer.cornerRadius = adviserImage.frame.height / 2
        adviserImage.clipsToBounds = true
    }
}

// MARK: Binding
extension FeedbackCell {
    private func setBinding() {
        
        dataInput.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                
                self?.colorView.backgroundColor =
                    UIUtil.hexStringToUIColor($0.category.color)
                self?.feedbackLabel.text = $0.title
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
                self?.dateLabel.text = dateFormatter.string(from: $0.date)
                
                guard let url =
                    URL(string: RemindFeedback.imgURL + $0.adviser.portrait) else { return }
                self?.adviserImage.kf
                    .setImage(with: url, placeholder: UIImage(named: "user-black"))
                
                self?.setLongTapListener()
                
            }).disposed(by: cellDisposeBag)
    }
    
    private func setLongTapListener() {
        self.rx.longPressGesture()
            .when(.recognized)
            .subscribe({ [weak self] _ in // 음... onNext가 필요없네...
                self?.viewModel?.onModFeedback(self?.index ?? -1)
            }).disposed(by: disposeBag)
    }
    
}
