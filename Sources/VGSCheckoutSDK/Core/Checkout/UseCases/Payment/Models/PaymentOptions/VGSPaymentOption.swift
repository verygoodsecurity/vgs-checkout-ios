//
//  VGSPaymentOption.swift
//  VGSCheckoutSDK

import Foundation

/// Payment options.
internal enum VGSPaymentOption {

	/// Saved card.
	case savedCard(_ card: VGSSavedCardModel)

	/// New card.
	case newCard

	/// Saved card associated value of type `VGSSavedCardModel` if .case matches .savedCard.
	internal var savedCardModel: VGSSavedCardModel? {
		switch self {
		case .savedCard(let cardModel):
			return cardModel
		default:
			return nil
		}
	}
}
