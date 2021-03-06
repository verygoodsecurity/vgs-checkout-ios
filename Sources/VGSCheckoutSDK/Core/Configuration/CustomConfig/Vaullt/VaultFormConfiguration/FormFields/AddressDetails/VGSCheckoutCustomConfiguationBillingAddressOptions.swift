//
//  VGSCheckoutCustomConfiguationBillingAddressOptions.swift
//  VGSCheckoutSDK

import Foundation

/// Holds billing address options for custom configuration.
public struct VGSCheckoutCustomConfiguationBillingAddressOptions {

	/// Country field options.
	public var countryOptions = VGSCheckoutCustomBillingAddressCountryOptions()

	/// Address line 1 field options.
	public var addressLine1Options = VGSCheckoutCustomBillingAddressLine1Options()

	/// Address line 2 field options.
	public var addressLine2Options = VGSCheckoutCustomBillingAddressLine2Options()

	/// City field options.
	public var cityOptions = VGSCheckoutCustomBillingAddressCityOptions()

	/// Postal code (zip for US) field options.
	public var postalCodeOptions = VGSCheckoutCustomBillingAddressPostalCodeOptions()

	/// no:doc
	public init() {}
}

/// Holds payment orchestration billing address options.
internal struct VGSCheckoutBillingAddressOptions {

  /// Country field options.
	internal var countryOptions = VGSCheckoutBillingAddressCountryOptions()

	/// Address line 1 field options.
	internal var addressLine1Options = VGSCheckoutBillingAddressLine1Options()

	/// Address line 2 field options.
	internal var addressLine2Options = VGSCheckoutBillingAddressLine2Options()

	/// City field options.
	internal var cityOptions = VGSCheckoutBillingAddressCityOptions()

	/// Postal code field options.
	internal var postalCodeOptions = VGSCheckoutBillingAddressPostalCodeOptions()

	/// no:doc
	internal init() {}
}
