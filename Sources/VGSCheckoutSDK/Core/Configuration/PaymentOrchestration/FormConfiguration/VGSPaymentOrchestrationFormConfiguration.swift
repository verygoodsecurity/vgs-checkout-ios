//
//  VGSPaymentOrchestrationFormConfiguration.swift
//  VGSCheckoutSDK

import Foundation

/// Payment optimization flow form configuration.
internal struct VGSPaymentOrchestrationFormConfiguration {

  /// Billing address visibility. Default is `.hidden`.
  var billingAddressVisibility: VGSCheckoutBillingAddressVisibility = .hidden

  /// Address options.
  var addressOptions = VGSCheckoutBillingAddressOptions()

	/// Form validation behavior, default is `.onSubmit`.
	var formValidationBehaviour = VGSCheckoutFormValidationBehaviour.onSubmit
  
  /// no:doc
  internal init() {}
}

/// no:doc
internal extension VGSPaymentOrchestrationFormConfiguration {

	/// `true` if billing address is visible.
	var isBillingAddressVisible: Bool {
		let isAddressVisible = billingAddressVisibility == .visible

		if isAddressVisible == false {
			return false
		}

		let addressFieldsOptions = [addressOptions.countryOptions, addressOptions.addressLine1Options, addressOptions.addressLine2Options, addressOptions.cityOptions, addressOptions.postalCodeOptions].compactMap {return $0 as? VGSCheckoutAddressOptionsProtocol}

		// Check if has visible address fields.
		let visibleAddressFields = addressFieldsOptions.filter({$0.visibility == .visible})

		if visibleAddressFields.isEmpty {
			return false
		}

		return true
	}
}
