//
//  VGSCheckoutSDKBasicConfigurationProtocol.swift
//  VGSCheckoutSDK
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
			- configuration: `VGSCheckoutCustomConfiguration` object, vault configuration.
	*/
	case vault(_ configuration: VGSCheckoutCustomConfiguration)

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
			if let vaultConfig = checkoutConfiguration as? VGSCheckoutCustomConfiguration {
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

	/// Custom headers from custom user configuration. Not available in multiplexing.
	internal var customHeaders: [String: String] {
		switch self {
		case .multiplexing:
			return [:]
		case .vault(let configuration):
			return configuration.routeConfiguration.requestOptions.customHeaders
		}
	}

	/// Extra data from custom user configuration. Not available in multiplexing.
	internal var extraData: [String: Any]? {
		switch self {
		case .multiplexing:
			return nil
		case .vault(let configuration):
			return configuration.routeConfiguration.requestOptions.extraData
		}
	}
}
