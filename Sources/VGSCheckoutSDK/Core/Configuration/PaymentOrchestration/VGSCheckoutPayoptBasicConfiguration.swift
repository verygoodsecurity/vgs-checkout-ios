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

	/// Billing address section visibility.
	var billingAddressVisibility: VGSCheckoutBillingAddressVisibility {get set}
}
