//
//  VGSCheckoutPaymentConfiguration.swift
//  VGSCheckoutSDK

import Foundation

/// Holds configuration with predefined setup for work with payment orchestration app, confirms to `VGSCheckoutBasicConfigurationProtocol`.
internal struct VGSCheckoutPaymentConfiguration: VGSCheckoutBasicConfigurationProtocol, VGSCheckoutPayoptBasicConfiguration {

	/// A callback to be run with a `VGSCheckoutPaymentConfiguration` on configuration setup succeed.
	/// - Parameters:
	///   - configuration:  `VGSCheckoutPaymentConfiguration` object, configuration.
	internal typealias CreateConfigurationSuccessCompletion = (_ configuration: inout VGSCheckoutPaymentConfiguration) -> Void

	/// A callback to be run with an error when configuration setup fail.
	/// - Parameters:
	///   - error: `Error` object, the error on configuration setup fail.
	internal typealias CreateConfigurationFailCompletion = (_ error: Error) -> Void

	// MARK: - Attributes

	/// `String` object, payment orchestration tenant id.
	internal let tenantId: String

	/// `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	internal let environment: String

	/// Order id.
	internal let orderId: String

	/// Holds order info.
	internal let paymentInfo: VGSPayoptTransfersOrderInfo

	/// Payment orchestration access token.
	private(set) internal var accessToken: String

	/// Max cards to fetch.
	internal static let maxSavedCardsCount: Int = 10

	// MARK: - Public

	/// Creates payment config.
	/// - Parameters:
	///   - accessToken: `String` object, should be valid access token for payment orchestration.
	///   - orderId: `String` object, orderId for payment orchestration.
	///   - tenantId: `String` object, payment orchestration tenant id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	///   - success: `CreateConfigurationSuccessCompletion` object, callback for configuration setup succeed.
	///   - failure: `CreateConfigurationFailCompletion` object, callback for configuration setup fail.
	public static func createConfiguration(accessToken: String, orderId: String, tenantId: String, environment: String = "sandbox", success: @escaping CreateConfigurationSuccessCompletion, failure: @escaping CreateConfigurationFailCompletion) {

		/// No additional options by default now.
		let options: VGSCheckoutPaymentOptions? = nil

//		guard VGSCheckoutCredentialsValidator.isJWTScopeValid(accessToken, vaultId: tenantId, environment: environment) else {
//			let error = NSError(domain: VGSCheckoutErrorDomain, code: VGSErrorType.invalidJWTToken.rawValue, userInfo: [NSLocalizedDescriptionKey: "JWT token is invalid or empty!"])
//			failure(error as Error)
//			return
//		}

		let vgsCollect = VGSCollect(id: tenantId, environment: environment)
		let orderAPIWorker = VGSPayoptTransfersOrderAPIWorker(vgsCollect: vgsCollect, accessToken: accessToken)
		orderAPIWorker.fetchPaymentConfiguration(for: orderId) { paymentInfo in
			print("succcess")

			var paymentCardConfiguration = VGSCheckoutPaymentConfiguration(accessToken: accessToken, orderId: orderId, paymentInfo: paymentInfo, tenantId: tenantId, environment: environment)
			success(&paymentCardConfiguration)
//			if let methods = options?.methods {
//				let savedCardsAPIWorker = VGSSavedPaymentMethodsAPIWorker(vgsCollect: vgsCollect, accessToken: accessToken)
//				savedCardsAPIWorker.fetchSavedPaymentMethods(methods) { savedCards in
//					paymentCardConfiguration.savedCards = savedCards
//					success(&paymentCardConfiguration)
//				} failure: { error in
//					success(&paymentCardConfiguration)
//				}
//			} else {
//				success(&paymentCardConfiguration)
//			}
		} failure: { error in
			failure(error)
		}
	}

	// MARK: - Initialization

	/// Configuration initializer.
	/// - Parameters:
	///   - accessToken: `String` object, should be valid access token for payment orchestration.
	///   - orderId: `String` object, should be valid orderId for payment orchestration.
	///   - paymentInfo: `VGSPayoptTransfersOrderInfo` object, order info.
	///   - tenantId: `String` object, payment orchestration tenant id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	internal init(accessToken: String, orderId: String, paymentInfo: VGSPayoptTransfersOrderInfo, tenantId: String, environment: String = "sandbox") {
		self.accessToken = accessToken
		self.orderId = orderId
		self.paymentInfo = paymentInfo
		self.tenantId = tenantId
		self.environment = environment
	}

	// MARK: - UI Configuration

	/// Checkout UI elements  configuration.
	internal var uiTheme: VGSCheckoutThemeProtocol = VGSCheckoutDefaultTheme()
  
  /// Enable save card option. If enabled - button with option to save card for future payments will be displayed. Default is `true`. Default **save card button** state is `selected`.
	internal var saveCardOptionEnabled: Bool = true

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
	internal var formValidationBehaviour: VGSCheckoutFormValidationBehaviour {
		get {
			return formConfiguration.formValidationBehaviour
		}

		set {
			formConfiguration.formValidationBehaviour = newValue
		}
	}

	internal var savedCards: [VGSSavedCardModel] = []

	/// An array of financial instruments ids representing saved cards.
	internal var savedPaymentCardsIds: [String] = []

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

/// Saved payment methods.
internal enum VGSCheckoutSavedPaymentMethods {

	case savedCards( _ ids: [String])
	//case userId(_ id: String)
}

/// Additional options
internal struct VGSCheckoutPaymentOptions {
	internal var methods: VGSCheckoutSavedPaymentMethods? = nil
}
