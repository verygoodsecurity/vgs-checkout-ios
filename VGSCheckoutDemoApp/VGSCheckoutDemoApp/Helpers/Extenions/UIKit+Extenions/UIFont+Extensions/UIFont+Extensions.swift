//
//  UIFont+Extensions.swift
//  VGSCheckoutDemoApp

import Foundation
#if canImport(UIKit)
import UIKit
#endif

extension UIFont {
	/// Provide font for traits.
	/// - Parameter traits: `UIFontDescriptor.SymbolicTraits` object.
	/// - Returns: `UIFont` object.
	func demoapp_withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
		let descriptor = fontDescriptor.withSymbolicTraits(traits)
		return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
	}

	/// Bold font.
	func demoapp_bold() -> UIFont {
		return demoapp_withTraits(traits: .traitBold)
	}

	/// Italic font.
	func demoapp_italic() -> UIFont {
		return demoapp_withTraits(traits: .traitItalic)
	}
}
