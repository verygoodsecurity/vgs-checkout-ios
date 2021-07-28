//
//  VGSCheckoutConfiguration.swift
//  VGSCheckout

import Foundation

/// Holds configuration for vault payment processing, confirms to `VGSCheckoutBasicConfigurationProtocol`.
public struct VGSCheckoutConfiguration: VGSCheckoutBasicConfigurationProtocol {

	/// `String` object, organization vault id.
	public let vaultID: String

	/// `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	public let environment: String

	/// Configuration initializer.
	/// - Parameters:
	///   - vaultID: `String` object, organization vault id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	public init(vaultID: String, environment: String) {
		self.vaultID = vaultID
		self.environment = environment
	}

	/// Route configuration, default is `VGSCheckoutRouteConfiguration` object.
	public var routeConfiguration: VGSCheckoutRouteConfiguration = VGSCheckoutRouteConfiguration()

  ///
  public var uiTheme: VGSCheckoutThemeProtocol = VGSCheckoutDefaultTheme()
  
	/// Form configuration options. Check `VGSCheckoutFormConfiguration` for default settings.
	internal var formConfiguration: VGSCheckoutFormConfiguration = VGSCheckoutFormConfiguration()

	/// Payment flow type (internal use only).
	internal let paymentFlowType: VGSPaymentFlowIdentifier = .vault

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

	/// Billing address country field options.
	public var billingAddressCountryFieldOptions: VGSCheckoutBillingAddressCountryOptions {
		get {
			return formConfiguration.addressOptions.countryOptions
		}

		set {
			formConfiguration.addressOptions.countryOptions = newValue
		}
	}

	/// Billing address, address line 1 field options.
	public var billingAddressLine1FieldOptions: VGSCheckoutBillingAddressLine1Options {
		get {
			return formConfiguration.addressOptions.addressLine1Options
		}

		set {
			formConfiguration.addressOptions.addressLine1Options = newValue
		}
	}

	/// Billing address, address line 2 field options.
	public var billingAddressLine2FieldOptions: VGSCheckoutBillingAddressLine2Options {
		get {
			return formConfiguration.addressOptions.addressLine2Options
		}

		set {
			formConfiguration.addressOptions.addressLine2Options = newValue
		}
	}

	/// Billing address city field options.
	public var billingAddressCityFieldOptions: VGSCheckoutBillingAddressCityOptions {
		get {
			return formConfiguration.addressOptions.cityOptions
		}

		set {
			formConfiguration.addressOptions.cityOptions = newValue
		}
	}

	/// Billing address postal code field options.
	public var billingAddressPostalCodeFieldOptions: VGSCheckoutBillingAddressPostalCodeOptions {
		get {
			return formConfiguration.addressOptions.postalCodeOptions
		}

		set {
			formConfiguration.addressOptions.postalCodeOptions = newValue
		}
	}

	/// Billing address mode.
	public var billingAddressMode: VGSCheckoutBillingAddressMode {
		get {
			return formConfiguration.billingAddressMode
		}

		set {
			formConfiguration.billingAddressMode = newValue
		}
	}
}
