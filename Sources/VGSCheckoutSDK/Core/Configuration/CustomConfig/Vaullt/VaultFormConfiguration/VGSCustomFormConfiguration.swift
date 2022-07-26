//
//  VGSCustomFormConfiguration.swift
//  VGSCheckoutSDK

import Foundation

///Custom Flow Form configuration.
internal struct VGSCustomFormConfiguration {

	/// Card details.
  var cardOptions = VGSCheckoutCardOptions()

	/// Address options.
  var addressOptions = VGSCheckoutCustomConfiguationBillingAddressOptions()

	/// Billing address visibility. Default is `.hidden` - address section is hidden.
  var billingAddressVisibility: VGSCheckoutBillingAddressVisibility = .hidden

	/// Form validation behavior, default is `.onSubmit`.
	var formValidationBehaviour = VGSCheckoutFormValidationBehaviour.onSubmit

	/// no:doc
  init() {}
}

/// no:doc
internal extension VGSCustomFormConfiguration {

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
