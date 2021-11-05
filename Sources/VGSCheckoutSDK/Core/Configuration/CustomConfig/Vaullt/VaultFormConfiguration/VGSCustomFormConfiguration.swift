//
//  VGSCustomFormConfiguration.swift
//  VGSCheckoutSDK

import Foundation

///Custom Flow Form configuration.
internal struct VGSCustomFormConfiguration {

	/// Card details.
  var cardOptions = VGSCheckoutCardOptions()

	/// Address options.
  var addressOptions = VGSCheckoutBillingAddressOptions()

	/// Billing address visibility. Default is `.hidden` - address section is hidden.
  var billingAddressVisibility: VGSCheckoutBillingAddressVisibility = .hidden

	/// Form validation behavior, default is `.onSubmit`.
	var formValidationBehaviour = VGSCheckoutFormValidationBehaviour.onEdit

	/// no:doc
  init() {}
}
