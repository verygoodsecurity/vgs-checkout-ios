//
//  VGSCheckoutPaymentMethod.swift
//  VGSCheckoutSDK
//

import Foundation

/// Describes selected payment method.
public enum VGSCheckoutPaymentMethod {

	/**
	 User paid with saved card option provided in saved payment methods.

	 - Parameters:
			- cardInfo: `VGSCheckoutPaymentCardInfo` object, contains information about selected card used for payment.
	*/
	case savedCard(_ cardInfo: VGSCheckoutPaymentCardInfo)

	/**
	 User paid with new card.

	 - Parameters:
			- requestResult: `VGSCheckoutRequestResult` object, contains information about new saved card payment.
			- cardInfo: `VGSCheckoutNewPaymentCardInfo` object, new card info object.
	*/
	case newCard(_ requestResult: VGSCheckoutRequestResult, _ cardInfo: VGSCheckoutNewPaymentCardInfo)

	/// Initializer.
	/// - Parameter paymentOption: `VGSPaymentOption` object, payment option.
//	internal init(paymentOption: VGSPaymentOption) {
//		switch paymentOption {
//		case .savedCard(let card):
//			self = .savedCard(VGSCheckoutPaymentCardInfo(id: card.id))
//			return
//		case .newCard:
//			fatalError("not implemented")
//		}
//	}
}

/// Holds additional information for payment method when user paid with selected card from provided saved cards.
public struct VGSCheckoutPaymentCardInfo {
	public let id: String
}

/// Holds additional information for payment method when user adds new card.
public struct VGSCheckoutNewPaymentCardInfo {

  /// `true` if user selected `Save card for future payments options`,  will be`nil` when `isSaveCardOptionEnabled` is set to `false`.
	public let shouldSave: Bool?

	/// no:doc
	internal init(shouldSave: Bool?) {
		self.shouldSave = shouldSave
	}
}
