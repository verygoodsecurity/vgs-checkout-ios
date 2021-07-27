//
//  VGSCheckoutMultiplexingBillingAddressOptions.swift
//  VGSCheckout

import Foundation

/// Holds multiplexing billing address options.
public struct VGSCheckoutMultiplexingBillingAddressOptions {

	/// Billing address mode. Default is `.fullAddress`.
	public var addressMode: VGSCheckoutBillingAddressMode = .fullAddress

	/// no:doc
	public init() {}
}

public struct VGSCheckoutBillingAddressOptions {

	public var countryOptions = VGSCheckoutBillingAddressCountryOptions()

	public var addressLine1Options = VGSCheckoutBillingAddressAddressLine1Options()

	public var addressLine2Options = VGSCheckoutBillingAddressAddressLine2Options()

	public var cityOptions = VGSCheckoutBillingAddressCityOptions()

	public var postalCodeOptions = VGSCheckoutBillingAddressPostalCodeOptions()

	public init() {}
}

public struct VGSCheckoutBillingAddressCountryOptions {
	public var fieldName = ""

	public init() {}
}

public struct VGSCheckoutBillingAddressAddressLine1Options {
	public var fieldName = ""

	public init() {}
}

public struct VGSCheckoutBillingAddressAddressLine2Options {
	public var fieldName = ""

	public init() {}
}

public struct VGSCheckoutBillingAddressCityOptions {
	public var fieldName = ""

	public init() {}
}

public struct VGSCheckoutBillingAddressPostalCodeOptions {
	public var fieldName = ""

	public init() {}
}
