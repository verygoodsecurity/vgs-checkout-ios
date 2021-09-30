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

	/// no:doc
  init() {}
}
