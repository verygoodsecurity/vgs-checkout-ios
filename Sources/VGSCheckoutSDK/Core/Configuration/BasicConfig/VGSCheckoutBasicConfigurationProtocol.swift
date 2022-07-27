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
  
  /// `String?` object, organization vault inbound route id or `nil`.
  var routeId: String? {get}
}

/// Internal protocol for VGSCheckout configuration.
internal protocol VGSCheckoutBasicConfigurationProtocol: VGSCheckoutConfigurationProtocol, VGSCheckoutConfigurationAnalyticsProtocol {}

/// Internal protocol for analytics details from VGSCheckout Configuration.
internal protocol VGSCheckoutConfigurationAnalyticsProtocol {

	/// Returns an array of features used
	func contentAnalytics() -> [String]
}

/// Defines checkout configuration type.
internal enum VGSCheckoutConfigurationType {

	/**
	 Payment instrument for general flow.

	 - Parameters:
			- configuration: `VGSCheckoutCustomConfiguration` object, custom configuration.
	*/
	case custom(_ configuration: VGSCheckoutCustomConfiguration)

	/**
	 Payment instrument for payment optimization add card flow.

	 - Parameters:
			- configuration: `VGSCheckoutAddCardConfiguration` object, pay opt add card configuration.
	*/
	case payoptAddCard(_ configuration: VGSCheckoutAddCardConfiguration)

	/**
	 Configuration for payment optimization transfers flow.

	 - Parameters:
			- configuration: `VGSCheckoutPaymentConfiguration` object, payment optimization payment configuration.
	*/
	case payoptTransfers(_ configuration: VGSCheckoutPaymentConfiguration)

	/// Initializer (failable).
	/// - Parameter configuration: `VGSCheckoutConfigurationProtocol` object, should be valid configuration.
	init?(configuration: VGSCheckoutConfigurationProtocol) {
		guard let checkoutConfiguration = configuration as? VGSCheckoutBasicConfigurationProtocol else {
			return nil
		}

		if let customConfig = checkoutConfiguration as? VGSCheckoutCustomConfiguration {
			self = .custom(customConfig)
			return
		}

		if let config
				= checkoutConfiguration as? VGSCheckoutAddCardConfiguration {
			self = .payoptAddCard(config)
			return
		}

		if let config = checkoutConfiguration as? VGSCheckoutPaymentConfiguration {
			self = .payoptTransfers(config)
			return
		}

		return nil
	}

	/// Checkout id.
	internal var mainCheckoutId: String {
		switch self {
		case .custom(let configuration):
			return configuration.vaultID
		case .payoptAddCard(let configuration):
			return configuration.tenantId
		case .payoptTransfers(let configuration):
			return configuration.tenantId
		}
	}

	/// An array of valid countries set by user.
	internal var validCountries: [String]? {
		switch self {
		case .custom(let configuration):
			return configuration.billingAddressCountryFieldOptions.validCountries
		case .payoptAddCard(let configuration):
			return configuration.billingAddressCountryFieldOptions.validCountries
		case .payoptTransfers(let configuration):
			return configuration.billingAddressCountryFieldOptions.validCountries
		}
	}

	/// Form validation behaviour.
	internal var formValidationBehaviour: VGSCheckoutFormValidationBehaviour {
		switch self {
		case .custom(let configuration):
			return configuration.formValidationBehaviour
		case .payoptAddCard(let configuration):
			return configuration.formValidationBehaviour
		case .payoptTransfers(let configuration):
			return configuration.formValidationBehaviour
		}
	}

	/// Checkout Configuration.
	internal var configuration: VGSCheckoutBasicConfigurationProtocol {
		switch self {
		case .custom(let configuration):
			return configuration
		case .payoptAddCard(let configuration):
			return configuration
		case .payoptTransfers(let configuration):
			return configuration
		}
	}

	/// `true` if address section is visible.
	internal var isAddressVisible: Bool {
		switch self {
		case .custom(let configuration):
			return configuration.formConfiguration.isBillingAddressVisible
		case .payoptAddCard(let configuration):
			return configuration.formConfiguration.isBillingAddressVisible
		case .payoptTransfers(let configuration):
			return configuration.formConfiguration.isBillingAddressVisible
		}
	}

	/// `true` if postal code field is visible.
	internal var isPostalCodeVisible: Bool {
		switch self {
		case .custom(let configuration):
			return configuration.billingAddressPostalCodeFieldOptions.visibility == .visible
		case .payoptAddCard(let configuration):
			return configuration.billingAddressPostalCodeFieldOptions.visibility == .visible
		case .payoptTransfers(let configuration):
			return configuration.billingAddressPostalCodeFieldOptions.visibility == .visible
		}
	}
}
