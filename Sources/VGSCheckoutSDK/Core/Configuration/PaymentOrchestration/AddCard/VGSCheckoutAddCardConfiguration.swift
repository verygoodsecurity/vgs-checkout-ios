//
//  VGSCheckoutAddCardConfiguration.swift
//  VGSCheckoutSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds configuration with predefined setup for work with payment orchestration app, confirms to `VGSCheckoutBasicConfigurationProtocol`.
public struct VGSCheckoutAddCardConfiguration: VGSCheckoutBasicConfigurationProtocol, VGSCheckoutPayoptBasicConfiguration {

	/// A callback to be run with a `VGSCheckoutAddCardConfiguration` on configuration setup succeed.
	/// - Parameters:
	///   - configuration:  `VGSCheckoutAddCardConfiguration` object, configuration.
	public typealias CreateConfigurationSuccessCompletion = (_ configuration: inout VGSCheckoutAddCardConfiguration) -> Void

	/// A callback to be run with an error when configuration setup fail.
	/// - Parameters:
	///   - error: `Error` object, the error on configuration setup fail.
	public typealias CreateConfigurationFailCompletion = (_ error: Error) -> Void

  // MARK: - Attributes
  
	/// `String` object, payment orchestration tenant id.
	public let tenantId: String

	/// `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	public let environment: String

	/// Enable save card option. If enabled - button with option to save card for future payments will be displayed. Default is `true`. Default **save card button** state is `selected`. **NOTE** User choice for save card option will not be stored on VGS side.
	public var isSaveCardOptionEnabled: Bool = true

	/// A boolean flag indicating whether user can remove saved cards. Default is `true`.
	public var isRemoveCardOptionEnabled: Bool = true

	/// Payment orchestration access token.
	private(set) internal var accessToken: String

	/// Saved cards models.
	internal var savedCards: [VGSSavedCardModel] = []

	/// An array of financial instruments ids representing saved cards.
	internal var savedPaymentCardsIds: [String] = []

	// MARK: - Public

	/// Creates Add Card config.
	/// - Parameters:
	///   - accessToken: `String` object, should be valid access token for payment orchestration.
	///   - tenantId: `String` object, payment orchestration tenant id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	///   - options: `VGSCheckoutPaymentOptions` object, additional checkout options, default is `nil`.
	///   - success: `CreateConfigurationSuccessCompletion` object, callback for configuration setup succeed.
	///   - failure: `CreateConfigurationFailCompletion` object, callback for configuration setup fail.
	public static func createConfiguration(accessToken: String, tenantId: String, environment: String = "sandbox", options: VGSCheckoutPaymentOptions? = nil, success: @escaping CreateConfigurationSuccessCompletion, failure: @escaping CreateConfigurationFailCompletion) {
//		guard VGSCheckoutCredentialsValidator.isJWTScopeValid(accessToken, vaultId: tenantId, environment: environment) else {
////			let error = NSError(domain: VGSCheckoutErrorDomain, code: VGSErrorType.invalidJWTToken.rawValue, userInfo: [NSLocalizedDescriptionKey: "JWT token is invalid or empty!"])
////			failure(error as Error)
//			return
//		}

		var savedCardConfiguration = VGSCheckoutAddCardConfiguration(accessToken: accessToken, tenantId: tenantId, environment: environment)

			let vgsCollect = VGSCollect(id: tenantId, environment: environment)

		/// For UITests use mocked data.
			if UIApplication.isRunningUITest && UIApplication.hasSavedCardInUITest {
				savedCardConfiguration.savedCards = [
					VGSSavedCardModel(id: "1", cardBrand: "visa", last4: "1231", expDate: "12/22", cardHolder: "John Smith"),
				VGSSavedCardModel(id: "2", cardBrand: "maestro", last4: "1488", expDate: "01/23", cardHolder: "John Smith")]
				success(&savedCardConfiguration)
				return
			}

			if let methods = options?.methods {
				let savedCardsAPIWorker = VGSSavedPaymentMethodsAPIWorker(vgsCollect: vgsCollect, accessToken: accessToken)
				savedCardsAPIWorker.fetchSavedPaymentMethods(methods) { savedCards in
					savedCardConfiguration.savedCards = savedCards
					success(&savedCardConfiguration)
				} failure: { error in
					success(&savedCardConfiguration)
				}
			} else {
				success(&savedCardConfiguration)
			}
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
	public var billingAddressCountryFieldOptions: VGSCheckoutBillingAddressCountryOptions {
    get {
      return formConfiguration.addressOptions.countryOptions
    }

    set {
      formConfiguration.addressOptions.countryOptions = newValue
    }
  }

	/// Billing address line 1 field options.
	public var billingAddressLine1FieldOptions: VGSCheckoutBillingAddressLine1Options {
		get {
			return formConfiguration.addressOptions.addressLine1Options
		}

		set {
			formConfiguration.addressOptions.addressLine1Options = newValue
		}
	}

	/// Billing address line 2 field options.
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
