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
  
  /// no:doc
  internal init() {}
}
