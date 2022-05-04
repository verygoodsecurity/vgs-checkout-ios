//
//  VGSCheckoutCustomConfiguration.swift
//  VGSCheckoutSDK

import Foundation

/// Holds configuration for vault payment processing with custom configuration, conforms to `VGSCheckoutBasicConfigurationProtocol`.
public struct VGSCheckoutCustomConfiguration: VGSCheckoutBasicConfigurationProtocol {

	/// `String` object, organization vault id.
	public let vaultID: String

	/// `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	public let environment: String

  // MARK: - Initialization
  
	/// Configuration initializer.
	/// - Parameters:
	///   - vaultID: `String` object, organization vault id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	public init(vaultID: String, environment: String = "sandbox") {
		self.vaultID = vaultID
		self.environment = environment
	}

  // MARK: - API Configuration
  
	/// Route configuration, default is `VGSCheckoutCustomRouteConfiguration` object.
	public var routeConfiguration: VGSCheckoutCustomRouteConfiguration = VGSCheckoutCustomRouteConfiguration()

  // MARK: - UI Configuration

  /// Form UI configuration attributes, default is `VGSCheckoutDefaultTheme` object.
  public var uiTheme: VGSCheckoutThemeProtocol = VGSCheckoutDefaultTheme()
  
	/// Form configuration options. Check `VGSCustomFormConfiguration` for default settings.
	internal var formConfiguration: VGSCustomFormConfiguration = VGSCustomFormConfiguration()

  // MARK: - Card Data Fields Configuration
  
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

  // MARK: - Billing Address Fields Configuration
  
  /// Billing address section visibility.
  public var billingAddressVisibility: VGSCheckoutBillingAddressVisibility {
    get {
      return formConfiguration.billingAddressVisibility
    }

    set {
      formConfiguration.billingAddressVisibility = newValue
    }
  }
  
	/// Billing address country field options.
	public var billingAddressCountryFieldOptions: VGSCheckoutCustomBillingAddressCountryOptions {
		get {
			return formConfiguration.addressOptions.countryOptions
		}

		set {
			formConfiguration.addressOptions.countryOptions = newValue
		}
	}

	/// Billing address, address line 1 field options.
	public var billingAddressLine1FieldOptions: VGSCheckoutCustomBillingAddressLine1Options {
		get {
			return formConfiguration.addressOptions.addressLine1Options
		}

		set {
			formConfiguration.addressOptions.addressLine1Options = newValue
		}
	}

	/// Billing address, address line 2 field options.
	public var billingAddressLine2FieldOptions: VGSCheckoutCustomBillingAddressLine2Options {
		get {
			return formConfiguration.addressOptions.addressLine2Options
		}

		set {
			formConfiguration.addressOptions.addressLine2Options = newValue
		}
	}

	/// Billing address city field options.
	public var billingAddressCityFieldOptions: VGSCheckoutCustomBillingAddressCityOptions {
		get {
			return formConfiguration.addressOptions.cityOptions
		}

		set {
			formConfiguration.addressOptions.cityOptions = newValue
		}
	}

	/// Billing address postal code field options.
	public var billingAddressPostalCodeFieldOptions: VGSCheckoutCustomBillingAddressPostalCodeOptions {
		get {
			return formConfiguration.addressOptions.postalCodeOptions
		}

		set {
			formConfiguration.addressOptions.postalCodeOptions = newValue
		}
	}

	/// Form validation behavior, default is `.onSubmit`.
	public var formValidationBehaviour: VGSCheckoutFormValidationBehaviour {
		get {
			return formConfiguration.formValidationBehaviour
		}

		set {
			formConfiguration.formValidationBehaviour = newValue
		}
	}

	/// Features usage analytics.
	internal func contentAnalytics() -> [String] {
		var content: [String] = []
		let requestOptions = routeConfiguration.requestOptions
		if !(requestOptions.extraData?.isEmpty ?? true) {
			content.append("custom_data")
		}
		if !(requestOptions.customHeaders.isEmpty) {
			content.append("custom_header")
		}
		if !(billingAddressCountryFieldOptions.validCountries?.isEmpty ?? true) {
			content.append("valid_countries")
		}

		switch billingAddressVisibility {
		case .hidden:
			content.append("billing_address_hidden")
		case .visible:
			content.append("billing_address_visible")
		}

		content.append(formValidationBehaviour.analyticsName)
		content.append(requestOptions.mergePolicy.analyticsName)

		return content
	}
}
