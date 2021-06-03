//
//  VGSCheckoutVaultConfiguration.swift
//  VGSCheckout

import Foundation

/// Holds configuration for vault payment processing, confirms to `VGSCheckoutBasicConfigurationProtocol`.
public struct VGSCheckoutVaultConfiguration: VGSCheckoutBasicConfigurationProtocol {

	/// Request configuration, default is `VGSCheckoutRequestConfiguration` object.
	public var routeConfiguration: VGSCheckoutRouteConfiguration = VGSCheckoutRouteConfiguration()

	/// Form configuration options. Check `VGSCheckoutVaultFormConfiguration` for default options.
	internal var formConfiguration: VGSCheckoutVaultFormConfiguration = VGSCheckoutVaultFormConfiguration()

	/// Payment flow type (internal use only).
	internal let paymentFlowType: VGSPaymentFlowIdentifier = .vault

	/// Initialization.
	public init() {}

	/// Card number field options.
	public var cardNumberFieldOptions: VGSCheckoutCardNumberOptions {
		get {
			return formConfiguration.cardOptions.cardNumberOptions
		}

		set {
			formConfiguration.cardOptions.cardNumberOptions = newValue
		}
	}

	/// Card holder field options.
	public var cardHolderFieldOptions: VGSCheckoutCardHolderOptions {
		get {
			return formConfiguration.cardOptions.cardHolderOptions
		}

		set {
			formConfiguration.cardOptions.cardHolderOptions = newValue
		}
	}

	/// Expiration date field options.
	public var expirationDateFieldOptions: VGSCheckoutExpirationDateOptions {
		get {
			return formConfiguration.cardOptions.expirationDateOptions
		}

		set {
			formConfiguration.cardOptions.expirationDateOptions = newValue
		}
	}

	// TODO: Add CVC
}

