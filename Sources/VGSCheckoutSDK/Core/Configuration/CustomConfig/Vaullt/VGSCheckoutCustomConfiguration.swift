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
  
	/// Route configuration, default is `VGSCheckoutRouteConfiguration` object.
	public var routeConfiguration: VGSCheckoutRouteConfiguration = VGSCheckoutRouteConfiguration()

  // MARK: - UI Configuration

  /// Form UI configuration attributes, default is `VGSCheckoutDefaultTheme` object.
  public var uiTheme: VGSCheckoutThemeProtocol = VGSCheckoutDefaultTheme()
  
	/// Form configuration options. Check `VGSCheckoutFormConfiguration` for default settings.
	internal var formConfiguration: VGSCustomFormConfiguration = VGSCustomFormConfiguration()

	/// Payment flow type (internal use only).
	internal let paymentFlowType: VGSPaymentFlowIdentifier = .vault

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

		content.append(requestOptions.mergePolicy.analyticsName)

    return content
  }
}
