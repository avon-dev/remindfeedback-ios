//
//  AdviserCell.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/04/06.
//  Copyright © 2020 avon. All rights reserved.
//

import Kingfisher
import RxSwift
import SnapKit
import UIKit

class AdviserCell: UITableViewCell {
    
    static let identifier = "adviserCell"
    private var cellDisposeBag = DisposeBag()
    
    var viewModel: AdviserListViewModelType? = nil
    var disposeBag = DisposeBag()
    let dataInput: PublishSubject<User>
    
    var index: Int?
    
    lazy var portrait: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.layer.cornerRadius = 48 / 2
        img.clipsToBounds = true
        self.addSubview(img)
        
        return img
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.addSubview(lbl)
        
        return lbl
    }()
    
    required init?(coder aDecoder: NSCoder) {
        dataInput = PublishSubject<User>()
        super.init(coder: aDecoder)
        setConstraints()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        dataInput = PublishSubject<User>()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setConstraints()
        setBinding()
    }
    
    deinit {
        cellDisposeBag = DisposeBag()
        disposeBag = DisposeBag()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        initialUI()
        disposeBag = DisposeBag()
    }

}

// MARK: UI
extension AdviserCell {
    private func setConstraints() {
        portrait.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.8)
            $0.width.equalTo(portrait.snp.height)
        }
        
        
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(portrait.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(portrait.snp.height)
        }
    }
    
    private func initialUI() {
        self.backgroundColor = .clear
    }
}

// MARK: Binding
extension AdviserCell {
    private func setBinding() {
        dataInput.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let url = URL(string: RemindFeedback.imgURL + $0.portrait)!
                self?.portrait.kf.setImage(with: url, placeholder: UIImage(named: "user-black"))
                self?.titleLabel.text = $0.nickname
            }).disposed(by: disposeBag)
    }
}
