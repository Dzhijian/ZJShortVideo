//
//  ZJColorsMacor.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import Foundation
import UIKit

let kClearColor         = UIColor.clear
let kWhiteColor         = UIColor.white
let kBlackColor         = UIColor.black
let kRedColor           = UIColor.red
let kBlueColor          = UIColor.blue
let kOrangeColor        = UIColor.orange
let kGrayColor          = UIColor.gray
let kLightTextColor     = UIColor.lightText
let kLightGrayColor     = UIColor.lightGray



func kRGBAColor(_ r: CGFloat, _ g: CGFloat, _ b:CGFloat, _ a: CGFloat? = nil) -> UIColor {
    return UIColor(red: r / 255.0, green: g/255.0, blue: b/255.0, alpha: a != nil ? a! : 1.0)
}



func kColorFromHex(rgbValue: Int) -> (UIColor) {
    
    return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,alpha: 1.0)
}

func kColorFromHex(rgbValue: Int, alpha: CGFloat) -> (UIColor) {
    
    return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,alpha: alpha)
}




func kColorFromHexString(rgbString: String) -> UIColor {
    var cString: String = rgbString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    
    if cString.characters.count < 6 {
        return UIColor.black
    }
    if cString.hasPrefix("0X") {
        cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2))
    }
    if cString.hasPrefix("#") {
        cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
    }
    if cString.characters.count != 6 {
        return UIColor.black
    }
    
    var range: NSRange = NSMakeRange(0, 2)
    let rString = (cString as NSString).substring(with: range)
    range.location = 2
    let gString = (cString as NSString).substring(with: range)
    range.location = 4
    let bString = (cString as NSString).substring(with: range)
    
    var r: UInt32 = 0x0
    var g: UInt32 = 0x0
    var b: UInt32 = 0x0
    Scanner.init(string: rString).scanHexInt32(&r)
    Scanner.init(string: gString).scanHexInt32(&g)
    Scanner.init(string: bString).scanHexInt32(&b)
    
    return kRGBAColor(CGFloat(r), CGFloat(g),CGFloat(b))

}

