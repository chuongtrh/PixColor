//
//  CustomInfiniteIndicator.swift
//  livecolor
//
//  Created by Sam on 6/30/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import UIKit

class CustomInfiniteIndicator: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    fileprivate func commonInit() {
        backgroundColor = UIColor.clear
    }

}
