//
//  VGSCheckoutMultiplexingConfiguration.swift
//  VGSCheckout

import Foundation

/// Holds configuration for multiplexing payment processing, confirms to `VGSCheckoutBasicConfigurationProtocol`.
public struct VGSCheckoutMultiplexingConfiguration: VGSCheckoutBasicConfigurationProtocol {

  /// Checkout UI elements  configuration.
  public var uiTheme: VGSCheckoutThemeProtocol = VGSCheckoutDefaultTheme()

	/// Payment flow type (internal use only).
	internal let paymentFlowType: VGSPaymentFlowIdentifier = .multiplexing

	/// Initialization.
	public init() {}
}
