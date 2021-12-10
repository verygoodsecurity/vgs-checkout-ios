//
//  VGSCheckoutSDKBasicConfigurationProtocol.swift
//  VGSCheckoutSDK
//

import Foundation

/// VGSCheckout configuration, public interface.
public protocol VGSCheckoutConfigurationProtocol {
  
  /// UI elements configuration theme.
  var uiTheme: VGSCheckoutThemeProtocol {get}

	/// `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	var environment: String {get}
}

/// Internal protocol for VGSCheckout configuration.
internal protocol VGSCheckoutBasicConfigurationProtocol: VGSCheckoutConfigurationProtocol, VGSCheckoutConfigurationAnalyticsProtocol {

	/// Payment flow type.
	var paymentFlowType: VGSPaymentFlowIdentifier {get}
}

/// Internal protocol for analytics details from VGSCheckout Configuration.
internal protocol VGSCheckoutConfigurationAnalyticsProtocol {
  
  /// Returns an array of features used
  func contentAnalytics() -> [String]
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
	case multiplexing(_ configuration:  VGSCheckoutMultiplexingAddCardConfiguration)

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
			if let multiplexingConfig = checkoutConfiguration as?  VGSCheckoutMultiplexingAddCardConfiguration {
				self = .multiplexing(multiplexingConfig)
				return
			} else {
				return nil
			}
		}
	}

	/// Checkout id.
	internal var mainCheckoutId: String {
		switch self {
		case .vault(let configuration):
			return configuration.vaultID
		case .multiplexing(let configuration):
			return configuration.tenantId
		}
	}

	/// An array of valid countries set by user.
	internal var validCountries: [String]? {
		switch self {
		case .vault(let configuration):
			return configuration.billingAddressCountryFieldOptions.validCountries
		case .multiplexing(let configuration):
			return configuration.billingAddressCountryFieldOptions.validCountries
		}
	}

	/// Form validation behaviour.
	internal var formValidationBehaviour: VGSCheckoutFormValidationBehaviour {
		switch self {
		case .vault(let configuration):
			return configuration.formValidationBehaviour
		case .multiplexing(let configuration):
			return configuration.formValidationBehaviour
		}
	}
  
  /// Checkout Configuration.
  internal var configuration: VGSCheckoutBasicConfigurationProtocol {
    switch self {
    case .vault(let configuration):
      return configuration
    case .multiplexing(let configuration):
      return configuration
    }
  }
}
