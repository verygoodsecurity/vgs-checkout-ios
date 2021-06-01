//
//  VGSCheckoutCardDetailsOptions.swift
//  VGSCheckout
//

import Foundation

/// Card details options.
public struct VGSCheckoutCardDetailsOptions {

	/// Card number field name (should be configured in your route on the dashboard).
	public var cardNumberFieldName: String = ""

	/// Expiration date field name (should be configured in your route on the dashboard)
	public var expirationDateFieldName: String = ""

	/// CVC field name (should be configured in your route on the dashboard)
	public var cvcFieldName: String = ""

	/// A boolean flag indicating whether card icon is hidden. Default is `false`.
	public var isCardIconHidden: Bool = false

	/// Card holder name field type. Default is `hidden`.
	public var cardHolderNameFieldType: VGSCheckoutCardHolderFieldType = .hidden

	/// Postal code field type. Default is `hidden`.
	public var postalCodeFieldType: VGSCheckoutPostalCodeFieldType = .hidden

//  Default value *all brands.
//	public var allowedCardBrands: VGSCollectCardBrands = Card

	/// no:doc
	public init() {}
}
