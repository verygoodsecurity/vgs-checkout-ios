//
//  VGSCheckoutSDKBillingAddressOptions.swift
//  VGSCheckoutSDK

import Foundation

/// Holds billing address options.
public struct VGSCheckoutBillingAddressOptions {

	/// Country field options.
	public var countryOptions = VGSCheckoutBillingAddressCountryOptions()

	/// Address line 1 field options.
	public var addressLine1Options = VGSCheckoutBillingAddressLine1Options()

	/// Address line 2 field options.
	public var addressLine2Options = VGSCheckoutBillingAddressLine2Options()

	/// City field options.
	public var cityOptions = VGSCheckoutBillingAddressCityOptions()

	/// Postal code (zip for US) field options.
	public var postalCodeOptions = VGSCheckoutBillingAddressPostalCodeOptions()

	/// no:doc
	public init() {}
}