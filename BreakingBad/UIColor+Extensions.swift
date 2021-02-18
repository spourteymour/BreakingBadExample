//
//  UIColor+Extensions.swift
//  BreakingBad
//
//  Created by Sepandat Pourtaymour on 16/02/2021.
//  Copyright © 2021 Sepandat Pourtaymour. All rights reserved.
//

import UIKit

extension UIColor {
	
	static func with(hexValue: String) -> UIColor {
		var cString:String = hexValue.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		
		if (cString.hasPrefix("#")) {
			cString.remove(at: cString.startIndex)
		}
		
		if ((cString.count) != 6) {
			return .clear
		}
		
		var rgbValue:UInt64 = 0
		Scanner(string: cString).scanHexInt64(&rgbValue)
		
		return UIColor(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
}
