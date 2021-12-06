//
//  VGSCheckoutSDKMultiplexingConfiguration.swift
//  VGSCheckoutSDK

import Foundation

/// Holds configuration with predefined setup for work with payment orchestration/multiplexing app, confirms to `VGSCheckoutBasicConfigurationProtocol`.
public struct VGSCheckoutMultiplexingConfiguration: VGSCheckoutBasicConfigurationProtocol {
  
  // MARK: - Attributes
  
	/// `String` object, payment orchestration tenant id.
	public let tenantId: String

	/// `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	public let environment: String

	/// Payment orchestration access token.
	private(set) public var accessToken: String

  // MARK: - Initialization
  
	/// Configuration initializer (failable).
	/// - Parameters:
  ///   - accessToken: `String` object, should be valid access token for payment orchestration.
	///   - tenantId: `String` object, payment orchestration tenant id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	public init?(accessToken: String, tenantId: String, environment: String = "sandbox") {
		guard VGSMultiplexingCredentialsValidator.isJWTScopeValid(accessToken, vaultId: tenantId, environment: environment) else {
            return nil
        }
    self.accessToken = accessToken
		self.tenantId = tenantId
		self.environment = environment
	}

  // MARK: - UI Configuration
  
	/// Checkout UI elements  configuration.
	public var uiTheme: VGSCheckoutThemeProtocol = VGSCheckoutDefaultTheme()
  
  /// Billing address visibility.
  public var billingAddressVisibility: VGSCheckoutBillingAddressVisibility {
    get {
      return formConfiguration.billingAddressVisibility
    }

    set {
      formConfiguration.billingAddressVisibility = newValue
    }
  }
  
  /// Billing address country field options.
  public var billingAddressCountryFieldOptions: VGSCheckoutMultiplexingBillingAddressCountryOptions {
    get {
      return formConfiguration.addressOptions.countryOptions
    }

    set {
      formConfiguration.addressOptions.countryOptions = newValue
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

  // MARK: - Internal
  
	/// Payment flow type (internal use only).
	internal let paymentFlowType: VGSPaymentFlowIdentifier = .multiplexing
  
  /// Form configuration options. Check `VGSCheckoutMultiplexingFormConfiguration` for default settings.
  internal var formConfiguration = VGSMultiplexingFormConfiguration()
  
  /// Features usage analytics.
  internal func contentAnalytics() -> [String] {
    var content: [String] = []
    if !(billingAddressCountryFieldOptions.validCountries?.isEmpty ?? true) {
      content.append("valid_countries")
    }

		content.append(formValidationBehaviour.analyticsName)
    return content
  }
}
