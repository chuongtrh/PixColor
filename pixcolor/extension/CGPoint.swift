//
//  CGPoint.swift
//  livecolor
//
//  Created by Sam on 5/29/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import Foundation
import UIKit
extension CGPoint {
    func rotate(angle:CGFloat) -> CGPoint {
//        let s:CGFloat = CGFloat(sinf(Float(angle)));
//        let c:CGFloat = CGFloat(cosf(Float(angle)));
//        return CGPoint(x: CGFloat(c * x - s * y), y: CGFloat(s * x + c * y));
        
        let initialPoint = CGPoint(x: x, y: y) // the point you want to rotate
        let translateTransform = CGAffineTransform(translationX: initialPoint.x, y: initialPoint.y)
        let rotationTransform = CGAffineTransform(rotationAngle: angle)
        let customRotation = (rotationTransform.concatenating(translateTransform.inverted())).concatenating(translateTransform)
        return initialPoint.applying(customRotation)
    }
}
