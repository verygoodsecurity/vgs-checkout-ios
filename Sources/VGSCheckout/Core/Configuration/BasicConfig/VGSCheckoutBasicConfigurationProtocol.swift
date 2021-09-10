//
//  VGSCheckoutBasicConfigurationProtocol.swift
//  VGSCheckout
//

import Foundation

/// VGSCheckout configuration, public interface.
public protocol VGSCheckoutConfigurationProtocol {
  
  /// UI elements configuration theme.
  var uiTheme: VGSCheckoutThemeProtocol {get}

	/// `String` object, organization vault id.
	var vaultID: String {get}

	/// `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	var environment: String {get}
}

/// Internal protocol for VGSCheckout configuration.
internal protocol VGSCheckoutBasicConfigurationProtocol: VGSCheckoutConfigurationProtocol {

	/// Payment flow type.
	var paymentFlowType: VGSPaymentFlowIdentifier {get}
  
}

/// Defines payment flow identifiers.
internal enum VGSPaymentFlowIdentifier {

	/// Use regular vault flow.
	case vault

	/// Use multiplexing flow for payment optimization.
	case multiplexing
}

/// Defines paymnet processing flow.
internal enum VGSPaymentInstrument {

	/**
	 Payment instrument for general flow.

	 - Parameters:
			- configuration: `VGSCheckoutConfiguration` object, vault configuration.
	*/
	case vault(_ configuration: VGSCheckoutConfiguration)

	/**
	 Payment instrument for multiplexing flow.

	 - Parameters:
			- configuration: `VGSCheckoutMultiplexingConfiguration` object, multiplexing configuration.
	*/
	case multiplexing(_ configuration: VGSCheckoutMultiplexingConfiguration)

	/// Initializer (failable).
	/// - Parameter configuration: `VGSCheckoutConfigurationProtocol` object, should be valid configuration.
	init?(configuration: VGSCheckoutConfigurationProtocol) {
		guard let checkoutConfiguration = configuration as? VGSCheckoutBasicConfigurationProtocol else {
			return nil
		}

		switch checkoutConfiguration.paymentFlowType {
		case .vault:
			if let vaultConfig = checkoutConfiguration as? VGSCheckoutConfiguration {
				self = .vault(vaultConfig)
				return
			} else {
				return nil
			}
		case .multiplexing:
			if let multiplexingConfig = checkoutConfiguration as? VGSCheckoutMultiplexingConfiguration {
				self = .multiplexing(multiplexingConfig)
				return
			} else {
				return nil
			}
		}
	}
}
