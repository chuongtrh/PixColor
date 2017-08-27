//
//  UIColor.swift
//  livecolor
//
//  Created by Sam on 5/26/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    func inverseColor() -> UIColor {
        var r:CGFloat = 0.0; var g:CGFloat = 0.0; var b:CGFloat = 0.0; var a:CGFloat = 0.0;
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            //let d:CGFloat = 1.0 - max(r,g,b)
            return UIColor(red: 1.0 + r, green: 1.0 - g , blue: 1.0 - b, alpha: 1.0)
        }
        return self
    }
    
    func whichColor() -> String{
        
        var (h,s,b,a) : (CGFloat, CGFloat, CGFloat, CGFloat) = (0,0,0,0)
        _ = self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        print("HSB range- h: \(h), s: \(s), v: \(b)")
        
        var colorTitle = ""
        
        switch (h, s, b) {
            
        // red
        case (0...0.138, 0.88...1.00, 0.75...1.00):
            colorTitle = "red"
        // yellow
        case (0.139...0.175, 0.30...1.00, 0.80...1.00):
            colorTitle = "yellow"
        // green
        case (0.176...0.422, 0.30...1.00, 0.60...1.00):
            colorTitle = "green"
        // teal
        case (0.423...0.494, 0.30...1.00, 0.54...1.00):
            colorTitle = "teal"
        // blue
        case (0.495...0.667, 0.30...1.00, 0.60...1.00):
            colorTitle = "blue"
        // purple
        case (0.668...0.792, 0.30...1.00, 0.40...1.00):
            colorTitle = "purple"
        // pink
        case (0.793...0.977, 0.30...1.00, 0.80...1.00):
            colorTitle = "pink"
        // brown
        case (0...0.097, 0.50...1.00, 0.25...0.58):
            colorTitle = "brown"
        // white
        case (0...1.00, 0...0.05, 0.95...1.00):
            colorTitle = "white"
        // grey
        case (0...1.00, 0, 0.25...0.94):
            colorTitle = "grey"
        // black
        case (0...1.00, 0...1.00, 0...0.07):
            colorTitle = "black"
        default:
            colorTitle = "Unknow"
        }
        
        return colorTitle
    }
}
