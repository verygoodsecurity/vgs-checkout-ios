//
//  VGSCheckoutPaymentConfiguration.swift
//  VGSCheckoutSDK

import Foundation

/// Holds configuration with predefined setup for work with payment orchestration app, confirms to `VGSCheckoutBasicConfigurationProtocol`.
public struct VGSCheckoutPaymentConfiguration: VGSCheckoutBasicConfigurationProtocol, VGSCheckoutPaymentOrchestrationBasicConfiguration {

	/// A callback to be run with a `VGSCheckoutPaymentConfiguration` on configuration setup succeed.
	/// - Parameters:
	///   - configuration:  `VGSCheckoutPaymentConfiguration` object, configuration.
	public typealias CreateConfigurationSuccessCompletion = (_ configuration: inout VGSCheckoutPaymentConfiguration) -> Void

	/// A callback to be run with an error when configuration setup fail.
	/// - Parameters:
	///   - error: `Error` object, the error on configuration setup fail.
	public typealias CreateConfigurationFailCompletion = (_ error: Error) -> Void

	// MARK: - Attributes

	/// `String` object, payment orchestration tenant id.
	public let tenantId: String

	/// `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	public let environment: String

	/// Order id.
	public let orderId: String

	/// Holds order info.
	internal let paymentInfo: VGSPayoptTransfersOrderInfo

	/// Payment orchestration access token.
	private(set) public var accessToken: String

	// MARK: - Public

	/// Creates payment config.
	/// - Parameters:
	///   - accessToken: `String` object, should be valid access token for payment orchestration.
	///   - orderId: `String` object, orderId for payment orchestration.
	///   - tenantId: `String` object, payment orchestration tenant id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	///   - options: `VGSCheckoutPaymentOptions` object, payment options.
	///   - success: `CreateConfigurationSuccessCompletion` object, callback for configuration setup succeed.
	///   - failure: `CreateConfigurationFailCompletion` object, callback for configuration setup fail.
	public static func createConfiguration(accessToken: String, orderId: String, tenantId: String, environment: String = "sandbox", options: VGSCheckoutPaymentOptions? = nil, success: @escaping CreateConfigurationSuccessCompletion, failure: @escaping CreateConfigurationFailCompletion) {

		var savedCardsToFetch = [String]()
		if let savedPaymentMethods = options?.methods {
			switch savedPaymentMethods {
			case .savedCards(let savedCards):
				if savedCards.count > 5 {
					//savedCardsToFetch = savedCards.prefix(5)
				}
			case .userId(let _):
				break
			}
		}

		guard VGSCheckoutCredentialsValidator.isJWTScopeValid(accessToken, vaultId: tenantId, environment: environment) else {
			let error = NSError(domain: VGSCheckoutErrorDomain, code: VGSErrorType.invalidJWTToken.rawValue, userInfo: [NSLocalizedDescriptionKey: "JWT token is invalid or empty!"])
			failure(error as Error)
			return
		}

		let vgsCollect = VGSCollect(id: tenantId, environment: environment)
		let orderAPIWorker = VGSPayoptTransfersOrderAPIWorker(vgsCollect: vgsCollect, accessToken: accessToken)
		orderAPIWorker.fetchPaymentConfiguration(for: orderId) { paymentInfo in
			print("succcess")

			var paymentCardConfiguration = VGSCheckoutPaymentConfiguration(accessToken: accessToken, orderId: orderId, paymentInfo: paymentInfo, tenantId: tenantId, environment: environment)
			if let methods = options?.methods {
				let savedCardsAPIWorker = VGSSavedPaymentMethodsAPIWorker(vgsCollect: vgsCollect, accessToken: accessToken)
				savedCardsAPIWorker.fetchSavedPaymentMethods(methods) { savedCards in
					paymentCardConfiguration.savedCards = savedCards
					success(&paymentCardConfiguration)
				} failure: { error in
					success(&paymentCardConfiguration)
				}
			} else {
				success(&paymentCardConfiguration)
			}
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
	public var uiTheme: VGSCheckoutThemeProtocol = VGSCheckoutDefaultTheme()
  
  /// Enable save card option. If enabled - button with option to save card for future payments will be displayed. Default is `true`. Default **save card button** state is `selected`.
  public var saveCardOptionEnabled: Bool = true

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

	/// Form validation behavior, default is `.onSubmit`.
	public var formValidationBehaviour: VGSCheckoutFormValidationBehaviour {
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

internal protocol VGSCheckoutPaymentOrchestrationBasicConfiguration {

	/// Form configuration options.
	var formConfiguration: VGSPaymentOrchestrationFormConfiguration {get set}

	var billingAddressCountryFieldOptions: VGSCheckoutBillingAddressCountryOptions {get set}

	var billingAddressVisibility: VGSCheckoutBillingAddressVisibility {get set}
}

public enum VGSCheckoutSavedPaymentMethods {
	case savedCards( _ ids: [String])
	case userId(_ id: String)
}

public struct VGSCheckoutPaymentOptions {
	public var methods: VGSCheckoutSavedPaymentMethods? = nil

	public init() {

	}
}
