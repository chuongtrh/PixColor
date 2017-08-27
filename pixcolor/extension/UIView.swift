//
//  UIView.swift
//  livecolor
//
//  Created by Sam on 5/27/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContext(self.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
