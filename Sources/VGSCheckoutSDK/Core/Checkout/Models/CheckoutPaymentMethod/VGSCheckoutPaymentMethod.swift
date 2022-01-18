//
//  VGSCheckoutPaymentMethod.swift
//  VGSCheckoutSDK
//

import Foundation

/// Enum describing selected payment method by user.
public enum VGSCheckoutPaymentMethod {
  case savedCard(_ cardInfo: VGSCheckoutPaymentCardInfo)
  case newCard(_ cardInfo: VGSCheckoutNewPaymentCardInfo)

	internal init(paymentOption: VGSPaymentOption) {
		switch paymentOption {
		case .savedCard(let card):
			self = .savedCard(VGSCheckoutPaymentCardInfo(id: card.id))
			return
		case .newCard:
			self = .newCard(VGSCheckoutNewPaymentCardInfo(shouldSave: false))
			return
		}
	}
}

/// Saved payment card details.
public struct VGSCheckoutPaymentCardInfo {
	public let id: String
}

/// New payment card details.
public struct VGSCheckoutNewPaymentCardInfo {
  /// `true` if selected to be saved for future payments.
  public let shouldSave: Bool
}
