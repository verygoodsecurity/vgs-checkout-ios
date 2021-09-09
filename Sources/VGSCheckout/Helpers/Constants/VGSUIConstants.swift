//
//  VGSUIConstants.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI constants.
internal struct VGSUIConstants {

	/// Form UI constants.
	internal	struct FormUI {

		/// Field view layout margins.
		static let fieldViewLayoutMargings: UIEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)

		/// Text field paddings.
		static let textFieldPaddings: UIEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
	}
}