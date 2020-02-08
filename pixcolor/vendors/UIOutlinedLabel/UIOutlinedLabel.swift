//
//  UIOutlinedLabel.swift
//  UIOutlinedLabel
//
//  Created by Geert-Jan Nilsen on 02/06/15.
//  Copyright (c) 2015 Yuppielabel.com All rights reserved.
//

import UIKit

class UIOutlinedLabel: UILabel {
    
    var outlineWidth: CGFloat = 1
    var outlineColor: UIColor = UIColor.white
    
    override func drawText(in rect: CGRect) {
        
        let strokeTextAttributes = [NSAttributedString.Key.strokeColor : outlineColor,NSAttributedString.Key.strokeWidth : -1 * outlineWidth] as [NSAttributedString.Key : Any]
        
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawText(in: rect)
    }
}
