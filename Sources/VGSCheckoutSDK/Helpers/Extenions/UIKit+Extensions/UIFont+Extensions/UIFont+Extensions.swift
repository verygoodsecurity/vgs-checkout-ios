//
//  UIFont+Extensions.swift
//  VGSCheckoutSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

public extension UIFont {
		static func vgsPreferredFont(forTextStyle style: TextStyle, weight: Weight) -> UIFont {
				let metrics = UIFontMetrics(forTextStyle: style)
				let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
				let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
				return metrics.scaledFont(for: font)
		}
}
