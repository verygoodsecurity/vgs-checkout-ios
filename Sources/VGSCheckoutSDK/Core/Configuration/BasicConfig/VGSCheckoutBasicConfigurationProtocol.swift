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
	 Payment instrument for multiplexing add card flow.

	 - Parameters:
			- configuration: `VGSCheckoutMultiplexingAddCardConfiguration` object, multiplexing add card configuration.
	*/
	case multiplexingAddCard(_ configuration: VGSCheckoutMultiplexingAddCardConfiguration)

	/**
	 Configuration for multiplexing payment flow.

	 - Parameters:
			- configuration: `VGSCheckoutMultiplexingPaymentConfiguration` object, multiplexing payment configuration.
	*/
	case multiplexingPayment(_ configuration: VGSCheckoutMultiplexingPaymentConfiguration)

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

		if let multiplexingAddCardConfig = checkoutConfiguration as? VGSCheckoutMultiplexingAddCardConfiguration {
			self = .multiplexingAddCard(multiplexingAddCardConfig)
			return
		}

		if let multiplexingPaymentConfig = checkoutConfiguration as? VGSCheckoutMultiplexingPaymentConfiguration {
			self = .multiplexingPayment(multiplexingPaymentConfig)
			return
		}

		return nil
	}

	/// Checkout id.
	internal var mainCheckoutId: String {
		switch self {
		case .custom(let configuration):
			return configuration.vaultID
		case .multiplexingAddCard(let configuration):
			return configuration.tenantId
		case .multiplexingPayment(let configuration):
			return configuration.tenantId
		}
	}

	/// An array of valid countries set by user.
	internal var validCountries: [String]? {
		switch self {
		case .custom(let configuration):
			return configuration.billingAddressCountryFieldOptions.validCountries
		case .multiplexingAddCard(let configuration):
			return configuration.billingAddressCountryFieldOptions.validCountries
		case .multiplexingPayment(let configuration):
			return configuration.billingAddressCountryFieldOptions.validCountries
		}
	}

	/// Form validation behaviour.
	internal var formValidationBehaviour: VGSCheckoutFormValidationBehaviour {
		switch self {
		case .custom(let configuration):
			return configuration.formValidationBehaviour
		case .multiplexingAddCard(let configuration):
			return configuration.formValidationBehaviour
		case .multiplexingPayment(let configuration):
			return configuration.formValidationBehaviour
		}
	}

	/// Checkout Configuration.
	internal var configuration: VGSCheckoutBasicConfigurationProtocol {
		switch self {
		case .custom(let configuration):
			return configuration
		case .multiplexingAddCard(let configuration):
			return configuration
		case .multiplexingPayment(let configuration):
			return configuration
		}
	}

	/// `true` if address section is visible.
	internal var isAddressVisible: Bool {
		switch self {
		case .custom(let configuration):
			return configuration.billingAddressVisibility == .visible
		case .multiplexingAddCard(let configuration):
			return configuration.billingAddressVisibility == .visible
		case .multiplexingPayment(let configuration):
			return configuration.billingAddressVisibility == .visible
		}
	}
}
