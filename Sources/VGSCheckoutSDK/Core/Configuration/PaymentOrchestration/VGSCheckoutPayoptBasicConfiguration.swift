//
//  VGSCheckoutPayoptBasicConfiguration.swift
//  VGSCheckoutSDK

import Foundation

/// Interface for pay opt configurations.
internal protocol VGSCheckoutPayoptBasicConfiguration {

	/// Form configuration options.
	var formConfiguration: VGSPaymentOrchestrationFormConfiguration {get set}

	/// Country billing address options.
	var billingAddressCountryFieldOptions: VGSCheckoutBillingAddressCountryOptions {get set}

	/// Address line 1 billing address options.
	var billingAddressLine1FieldOptions: VGSCheckoutBillingAddressLine1Options {get set}

	/// Address line 2 billing address options.
	var billingAddressLine2FieldOptions: VGSCheckoutBillingAddressLine2Options {get set}

	/// City billing address options.
	var billingAddressCityFieldOptions: VGSCheckoutBillingAddressCityOptions {get set}

	/// Postal code billing address options.
	var billingAddressPostalCodeFieldOptions: VGSCheckoutBillingAddressPostalCodeOptions {get set}

	/// Billing address section visibility.
	var billingAddressVisibility: VGSCheckoutBillingAddressVisibility {get set}
}
