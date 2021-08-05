//
//  VGSCheckoutFormConfiguration.swift
//  VGSCheckout

import Foundation

/// Form configuration.
public struct VGSCheckoutFormConfiguration {

	/// Card details.
	public var cardOptions = VGSCheckoutCardOptions()

	/// Address options.
	public var addressOptions = VGSCheckoutBillingAddressOptions()

	/// Billing address visibility. Default is `.hidden` - address section is hidden and `addressOptions` fields will be ignored.
	public var billingAddressVisibility: VGSCheckoutBillingAddressVisibility = .hidden

	/// no:doc
	public init() {}
}
