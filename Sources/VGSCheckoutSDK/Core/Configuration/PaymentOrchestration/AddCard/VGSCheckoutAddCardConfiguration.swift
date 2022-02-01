//
//  VGSCheckoutAddCardConfiguration.swift
//  VGSCheckoutSDK

import Foundation

/// Holds configuration with predefined setup for work with payment orchestration app, confirms to `VGSCheckoutBasicConfigurationProtocol`.
internal struct VGSCheckoutAddCardConfiguration: VGSCheckoutBasicConfigurationProtocol, VGSCheckoutPayoptBasicConfiguration {

	/// A callback to be run with a `VGSCheckoutAddCardConfiguration` on configuration setup succeed.
	/// - Parameters:
	///   - configuration:  `VGSCheckoutAddCardConfiguration` object, configuration.
	internal typealias CreateConfigurationSuccessCompletion = (_ configuration: inout VGSCheckoutAddCardConfiguration) -> Void

	/// A callback to be run with an error when configuration setup fail.
	/// - Parameters:
	///   - error: `Error` object, the error on configuration setup fail.
	internal typealias CreateConfigurationFailCompletion = (_ error: Error) -> Void

  // MARK: - Attributes
  
	/// `String` object, payment orchestration tenant id.
	internal let tenantId: String

	/// `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	internal let environment: String

	/// Payment orchestration access token.
	private(set) internal var accessToken: String

	// MARK: - Public

	/// Creates Add Card config.
	/// - Parameters:
	///   - accessToken: `String` object, should be valid access token for payment orchestration.
	///   - tenantId: `String` object, payment orchestration tenant id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	///   - success: `CreateConfigurationSuccessCompletion` object, callback for configuration setup succeed.
	///   - failure: `CreateConfigurationFailCompletion` object, callback for configuration setup fail.
	internal static func createConfiguration(accessToken: String, tenantId: String, environment: String = "sandbox", success: @escaping CreateConfigurationSuccessCompletion, failure: @escaping CreateConfigurationFailCompletion) {
		guard VGSCheckoutCredentialsValidator.isJWTScopeValid(accessToken, vaultId: tenantId, environment: environment) else {
//			let error = NSError(domain: VGSCheckoutErrorDomain, code: VGSErrorType.invalidJWTToken.rawValue, userInfo: [NSLocalizedDescriptionKey: "JWT token is invalid or empty!"])
//			failure(error as Error)
			return
		}

		var saveCardConfiguration = VGSCheckoutAddCardConfiguration(accessToken: accessToken, tenantId: tenantId, environment: environment)
		success(&saveCardConfiguration)
	}

  // MARK: - Initialization
  
	/// Configuration initializer.
	/// - Parameters:
  ///   - accessToken: `String` object, should be valid access token for payment orchestration.
	///   - tenantId: `String` object, payment orchestration tenant id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	internal init(accessToken: String, tenantId: String, environment: String = "sandbox") {
    self.accessToken = accessToken
		self.tenantId = tenantId
		self.environment = environment
	}

  // MARK: - UI Configuration
  
	/// Checkout UI elements  configuration.
	internal var uiTheme: VGSCheckoutThemeProtocol = VGSCheckoutDefaultTheme()
  
  /// Billing address visibility.
	internal var billingAddressVisibility: VGSCheckoutBillingAddressVisibility {
    get {
      return formConfiguration.billingAddressVisibility
    }

    set {
      formConfiguration.billingAddressVisibility = newValue
    }
  }
  
  /// Billing address country field options.
	internal var billingAddressCountryFieldOptions: VGSCheckoutBillingAddressCountryOptions {
    get {
      return formConfiguration.addressOptions.countryOptions
    }

    set {
      formConfiguration.addressOptions.countryOptions = newValue
    }
  }

	/// Form validation behavior, default is `.onSubmit`.
	internal var formValidationBehaviour: VGSCheckoutFormValidationBehaviour {
		get {
			return formConfiguration.formValidationBehaviour
		}

		set {
			formConfiguration.formValidationBehaviour = newValue
		}
	}

  // MARK: - Internal
  
  /// Form configuration options. Check `VGSPaymentOrchestrationFormConfiguration` for default settings.
  internal var formConfiguration = VGSPaymentOrchestrationFormConfiguration()
  
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
