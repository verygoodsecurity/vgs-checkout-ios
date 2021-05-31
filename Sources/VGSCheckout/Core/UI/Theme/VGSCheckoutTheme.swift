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
