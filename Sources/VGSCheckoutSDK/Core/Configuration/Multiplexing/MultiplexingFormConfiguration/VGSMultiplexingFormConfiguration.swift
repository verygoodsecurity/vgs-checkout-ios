//
//  VGSCheckoutMultiplexingFormConfiguration.swift
//  VGSCheckoutSDK

import Foundation

/// Multiplexing Flow Form configuration.
internal struct VGSMultiplexingFormConfiguration {

  /// Billing address visibility. Default is `.hidden`.
  var billingAddressVisibility: VGSCheckoutBillingAddressVisibility = .hidden

  /// Address options.
  var addressOptions = VGSCheckoutMultiplexingBillingAddressOptions()

	/// Form validation behavior, default is `.onSubmit`.
	var formValidationBehaviour = VGSCheckoutFormValidationBehaviour.onSubmit
  
  var showSaveCardOption = true
  
  /// no:doc
  internal init() {}
}
