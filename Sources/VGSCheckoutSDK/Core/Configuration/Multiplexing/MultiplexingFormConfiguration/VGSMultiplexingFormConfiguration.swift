//
//  VGSCheckoutMultiplexingFormConfiguration.swift
//  VGSCheckoutSDK

import Foundation

/// Multiplexing Flow Form configuration.
internal struct VGSMultiplexingFormConfiguration {

  /// Billing address visibility. Default is `.hidden` - address section is hidden and `addressOptions` fields will be ignored.
  var billingAddressVisibility: VGSCheckoutBillingAddressVisibility = .hidden

  /// no:doc
  internal init() {}
}
