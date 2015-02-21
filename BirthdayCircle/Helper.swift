//
//  Helper.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/13.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import Foundation
func HexUIColor (hex:String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
    
    if (cString.hasPrefix("#")) {
        cString = cString.substringFromIndex(advance(cString.startIndex, 1))
    }
    
    if (countElements(cString) != 6) {
        return UIColor.grayColor()
    }
    
    var rgbValue:UInt32 = 0
    NSScanner(string: cString).scanHexInt(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


func GetUserAvatarFromDisk() -> UIImage? {
    let documentURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last as NSURL
    let imgURL = documentURL.URLByAppendingPathComponent("portrait.png")
    
    if let data = NSData(contentsOfURL: imgURL) {
        return UIImage(data: data)
    }
    return nil
    
}