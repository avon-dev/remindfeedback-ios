//
//  FriendCell.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/03/23.
//  Copyright © 2020 avon. All rights reserved.
//

import Kingfisher
import RxSwift
import UIKit

class FriendCell: UITableViewCell {
    
    static let identifier = "friendCell"

    private let cellDisposeBag = DisposeBag()
    
    var viewModel: FriendViewModelType? = nil
    var disposeBag = DisposeBag()
    let onData: AnyObserver<User>
    
    required init?(coder aDecoder: NSCoder) {
        
        let data = PublishSubject<User>()
        onData = data.asObserver()
        
        super.init(coder: aDecoder)

        data.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let url = URL(string: RemindFeedback.imgURL + $0.portrait)!
                self?.portraitImage.kf.setImage(with: url, placeholder: UIImage(named: "user-black"))
                self?.portraitImage.layer.cornerRadius = (self?.portraitImage.frame.height ?? 47) / 2
                self?.portraitImage.clipsToBounds = true
                self?.nameLabel.text = $0.nickname
                self?.statusLabel.text = $0.introduction
            })
            .disposed(by: cellDisposeBag)
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
    
    @IBOutlet weak var portraitImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    var index: Int = -1

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
