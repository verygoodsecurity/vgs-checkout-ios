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
