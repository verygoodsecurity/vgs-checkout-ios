//
//  VGSAddCardFormBlock.swift
//  VGSCheckout

import Foundation

/// Defines UI form blocks.
internal enum VGSAddCardFormBlock {

	/// Card holder.
	case cardHolder

	/// Card details.
	case cardDetails

	/// Address info.
	case addressInfo

	/// Corresponding form section.
	internal var formSection: VGSFormSection {
		switch self {
		case .cardHolder, .cardDetails:
			return .card
		case .addressInfo:
			return .billingAddress
		}
	}
}

/// Defines form section UI block.
internal enum VGSFormSection {

	/// Card data section.
	case card

	/// Billing address section.
	case billingAddress
}
