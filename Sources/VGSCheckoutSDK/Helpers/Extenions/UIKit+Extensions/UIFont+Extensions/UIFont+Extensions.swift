//
//  UIFont+Extensions.swift
//  VGSCheckoutSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// no:doc
public extension UIFont {
	/// Returns font with textStyle and weight.
	/// - Parameters:
	///   - style: `TextStyle` object, font text style.
	///   - weight: `Weight` object, font weight.
	/// - Returns: `UIFont` object.
		static func vgsPreferredFont(forTextStyle style: TextStyle, weight: Weight) -> UIFont {
				let metrics = UIFontMetrics(forTextStyle: style)
				let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
				let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
				return metrics.scaledFont(for: font)
		}
}
