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

	/// Billing address mode. Default is `.noAddress` - address section is hidden and `addressOptions` will be ignored.
	public var billingAddressMode: VGSCheckoutBillingAddressMode = .noAddress

	/// no:doc
	public init() {}
}
