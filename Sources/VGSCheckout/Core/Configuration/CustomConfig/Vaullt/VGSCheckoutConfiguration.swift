//
//  VGSCheckoutConfiguration.swift
//  VGSCheckout

import Foundation

/// Holds configuration for vault payment processing, confirms to `VGSCheckoutBasicConfigurationProtocol`.
public struct VGSCheckoutConfiguration: VGSCheckoutBasicConfigurationProtocol {

	/// Route configuration, default is `VGSCheckoutRouteConfiguration` object.
	public var routeConfiguration: VGSCheckoutRouteConfiguration = VGSCheckoutRouteConfiguration()

	/// Form configuration options. Check `VGSCheckoutFormConfiguration` for default settings.
	internal var formConfiguration: VGSCheckoutFormConfiguration = VGSCheckoutFormConfiguration()

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

	/// CVC field options.
	public var cvcFieldOptions: VGSCheckoutCVCOptions {
		get {
			return formConfiguration.cardOptions.cvcOptions
		}

		set {
			formConfiguration.cardOptions.cvcOptions = newValue
		}
	}
}
