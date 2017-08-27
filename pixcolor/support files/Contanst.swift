//
//  Contanst.swift
//  livecolor
//
//  Created by Sam on 6/15/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import Foundation
import UIColor_Hex_Swift

let drak_color:UIColor = UIColor(hexString: "4A4A4A")!
let gray_color:UIColor = UIColor(hexString: "F6F5F5")!
let background_color:UIColor = UIColor(hexString: "f3f3f3")!

func font_regular(size:CGFloat)->UIFont!{
    return UIFont(name: "HelveticaNeue", size: size)
}
func font_medium(size:CGFloat)->UIFont!{
    return UIFont(name: "HelveticaNeue-Medium", size: size)
}
func font_light(size:CGFloat)->UIFont!{
    return UIFont(name: "HelveticaNeue-Light", size: size)
}
func font_bold(size:CGFloat)->UIFont!{
    return UIFont(name: "HelveticaNeue-Bold", size: size)
}

func printFonts() {
    let fontFamilyNames = UIFont.familyNames
    for familyName in fontFamilyNames {
        print("------------------------------")
        print("Font Family Name = [\(familyName)]")
        let names = UIFont.fontNames(forFamilyName: familyName)
        print("Font Names = [\(names)]\n")
    }
}
