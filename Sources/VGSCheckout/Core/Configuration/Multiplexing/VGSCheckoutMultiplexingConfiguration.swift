//
//  VGSCheckoutMultiplexingConfiguration.swift
//  VGSCheckout

import Foundation

/// Holds configuration for multiplexing payment processing, confirms to `VGSCheckoutBasicConfigurationProtocol`.
public struct VGSCheckoutMultiplexingConfiguration: VGSCheckoutBasicConfigurationProtocol {

	/// `String` object, organization vault id.
	public let vaultID: String

	/// `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	public let environment: String

	/// Billing address options.
	public var billingAddressOptions: VGSCheckoutMultiplexingBillingAddressOptions = VGSCheckoutMultiplexingBillingAddressOptions()

	/// Configuration initializer.
	/// - Parameters:
	///   - vaultID: `String` object, organization vault id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	public init(vaultID: String, environment: String) {
		self.vaultID = vaultID
		self.environment = environment
	}

  /// Checkout UI elements  configuration.
  public var uiTheme: VGSCheckoutThemeProtocol = VGSCheckoutDefaultTheme()

	/// Payment flow type (internal use only).
	internal let paymentFlowType: VGSPaymentFlowIdentifier = .multiplexing
}
