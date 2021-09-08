//
//  UIColor+Extensions.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal extension UIColor {
	convenience init(hexString: String) {
				 let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
				 var int = UInt64()
				 Scanner(string: hex).scanHexInt64(&int)
				 let a, r, g, b: UInt64
				 switch hex.count {
				 case 3: // RGB (12-bit)
						 (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
				 case 6: // RGB (24-bit)
						 (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
				 case 8: // ARGB (32-bit)
						 (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
				 default:
						 (a, r, g, b) = (255, 0, 0, 0)
				 }
				 self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
		 }
}

// This code is taken from https://github.com/noahsark769/ColorCompatibility
// Thanks to Noah Gilmore.
// Copyright (c) 2019 Noah Gilmore <noah.w.gilmore@gmail.com>

public extension UIColor {

	/// System background color (white).
	static var vgsSystemBackground: UIColor {
			if #available(iOS 13, *) {
                return .systemGroupedBackground
			}

		return .groupTableViewBackground
	}

	/// Input text color (black).
	static var vgsInputBlackTextColor: UIColor {
		if #available(iOS 13.0, *) {
			return UIColor {(traits) -> UIColor in
				return traits.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
			}
		} else {
			return .black
		}
	}

	/// VGS section title color (with fallback to earlier versions).
	static var vgsSectionTitleColor: UIColor {
		if #available(iOS 13.0, *) {
			return label
		} else {
			return UIColor(hexString: "#1C1C1E")
		}
	}

	/// VGS section background color (with fallback to earlier versions).
	static var vgsSectionBackgroundColor: UIColor {
		if #available(iOS 13.0, *) {
			return UIColor.secondarySystemGroupedBackground
		} else {
			return .white
		}
	}

	/// VGS text field hint color (with fallback to earlier versions).
	static var vgsTextFieldHintTextColor: UIColor {
		if #available(iOS 13.0, *) {
			return UIColor.systemGray2
		} else {
			return UIColor(hexString: "#AEAEB2")
		}
	}
}
