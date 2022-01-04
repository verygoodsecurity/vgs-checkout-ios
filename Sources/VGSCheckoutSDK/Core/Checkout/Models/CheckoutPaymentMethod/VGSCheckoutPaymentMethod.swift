//
//  VGSCheckoutPaymentMethod.swift
//  VGSCheckoutSDK
//

import Foundation

/// Enum describing selected payment method by user.
public enum VGSCheckoutPaymentMethod {
  case savedCard(_ cardInfo: VGSCheckoutPaymentCardInfo)
  case newCard(_ cardInfo: VGSCheckoutNewPaymentCardInfo)
}

/// Saved payment card details.
public struct VGSCheckoutPaymentCardInfo {
  let isDefault: Bool
//  let last4: String
//  let cardBrand: VGSCheckoutPaymentCards.CardBrand
}

/// New payment card details.
public struct VGSCheckoutNewPaymentCardInfo {
  let shouldSave: Bool
//  let last4: String
//  let cardBrand: VGSCheckoutPaymentCards.CardBrand
}
