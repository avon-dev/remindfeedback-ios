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
