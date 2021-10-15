//
//  VGSCheckoutMultiplexingFormConfiguration.swift
//  VGSCheckoutSDK

import Foundation

/// Multiplexing Flow Form configuration.
internal struct VGSMultiplexingFormConfiguration {

  /// Billing address visibility. Default is `.hidden`.
  var billingAddressVisibility: VGSCheckoutBillingAddressVisibility = .hidden

  /// no:doc
  internal init() {}
}
