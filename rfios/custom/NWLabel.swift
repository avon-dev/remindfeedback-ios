//
//  NWLabel.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/18.
//  Copyright © 2019 avon. All rights reserved.
//

import UIKit

@IBDesignable class NWLabel: UILabel {
    
    @IBInspectable var topPadding: CGFloat {
        set {
            self.topPadding = newValue
        }
        get {
            return self.topPadding
        }
    }

    @IBInspectable var leftPadding: CGFloat {
        set {
            self.leftPadding = newValue
        }
        get {
            return self.leftPadding
        }
    }

    @IBInspectable var bottomPadding: CGFloat {
        set {
            self.bottomPadding = newValue
        }
        get {
            return self.bottomPadding
        }
    }

    @IBInspectable var rightPadding: CGFloat {
        set {
            self.rightPadding = newValue
        }
        get {
            return self.rightPadding
        }
    }

    @IBInspectable var padding: UIEdgeInsets { 
        set {
            self.padding = UIEdgeInsets(top: self.topPadding, left: self.leftPadding, bottom: self.bottomPadding, right: self.rightPadding)
        }
        get {
            return self.padding
        }
    }
    
    override func drawText(in rect: CGRect) {
        let paddingRect = rect.inset(by: padding)
        super.drawText(in: paddingRect)
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
