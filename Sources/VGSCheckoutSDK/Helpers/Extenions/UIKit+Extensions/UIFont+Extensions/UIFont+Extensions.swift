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
	///   - maximumPointSize: `CGFloat?` object, max font size in points, default is `nil`.
	/// - Returns: `UIFont` object.
		static func vgsPreferredFont(forTextStyle style: TextStyle, weight: Weight, maximumPointSize: CGFloat? = nil) -> UIFont {
				let metrics = UIFontMetrics(forTextStyle: style)
				let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
				let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)

				if let maximumPointSize = maximumPointSize {
					return metrics.scaledFont(for: font, maximumPointSize: maximumPointSize)
				}

				return metrics.scaledFont(for: font)
		}
}
