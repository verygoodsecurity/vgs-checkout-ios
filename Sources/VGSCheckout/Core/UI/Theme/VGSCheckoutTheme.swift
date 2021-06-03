//
//  VGSCheckoutTheme.swift
//  VGSCheckout

import Foundation

#if canImport(UIKit)
import UIKit
#endif

struct VGSCheckoutTheme {
	struct CardPaymentTheme {
		struct PaymentButton {
			static var backgroundColor: UIColor = UIColor.systemPurple
			static var opacity: CGFloat = 0.60
			static var titleOpacity: CGFloat = 0.8
			static var successColor: UIColor = UIColor.systemGreen
			static var cornerRadius: CGFloat = 6
		}
	}
}

public struct VGSCheckoutUITheme {
	public var textFieldTheme = VGSCheckoutTextFieldTheme()

	public var colorTheme: VGSCheckoutColorThemeProtocol?
}

public protocol VGSCheckoutColorThemeProtocol {
		var textFieldTextColor: UIColor {get}
	  
		var text1: UIColor { get } // heading
		var text2: UIColor { get } // body
		var text3: UIColor { get } // system
		var secondaryText1: UIColor { get }
		var main1: UIColor { get } // backgrounds
		var main2: UIColor { get } // cells, default buttons
		var tint1: UIColor { get } // border
		var neutral1: UIColor { get } //
		var disabled1: UIColor { get }
		var error1: UIColor { get }
		var success1: UIColor { get } // success message icon and navbar
}


public struct VGSCheckoutTextFieldTheme {
	public var font: UIFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.systemFont(ofSize: 14))
}
