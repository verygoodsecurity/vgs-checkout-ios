//
//  VGSCheckoutBillingAddressOptions.swift
//  VGSCheckout

import Foundation

public struct VGSCheckoutBillingAddressOptions {

	public var countryOptions = VGSCheckoutBillingAddressCountryOptions()

	public var addressLine1Options = VGSCheckoutBillingAddressAddressLine1Options()

	public var addressLine2Options = VGSCheckoutBillingAddressAddressLine2Options()

	public var cityOptions = VGSCheckoutBillingAddressCityOptions()

	public var postalCodeOptions = VGSCheckoutBillingAddressPostalCodeOptions()

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
