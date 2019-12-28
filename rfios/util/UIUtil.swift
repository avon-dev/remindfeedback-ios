//
//  ColorUtil.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/12/07.
//  Copyright © 2019 avon. All rights reserved.
//

import UIKit

class UIUtil {
    
    /// 사용자가 사용하는 단말기의 화면 크기
    static var screenSize: CGRect!
    
    /// 단말기 화면의 가로 크기
    static var screenWidth: CGFloat!
    
    /// 단말기 화면의 세로 크기
    static var screenHeight: CGFloat!
    
    static func hexStringToUIColor (_ hex:String) -> UIColor {
        var hexFormatted = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
