//
//  UIBorderedLabel.swift
//  RottenTomatoes
//
//  Created by Hao Sun on 2/6/15.
//  Copyright (c) 2015 Hao Sun. All rights reserved.
//

import UIKit

class UIBorderedLabel: UILabel {
    var topInset:       CGFloat = 0
    var rightInset:     CGFloat = 5.0
    var bottomInset:    CGFloat = 0
    var leftInset:      CGFloat = 5.0
    
    override func drawTextInRect(rect: CGRect) {
        var insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        self.setNeedsLayout()
        return super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}
