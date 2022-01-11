//
//  VGSCheckoutMultiplexingPaymentConfiguration.swift
//  VGSCheckoutSDK

import Foundation

/// Holds configuration with predefined setup for work with payment orchestration/multiplexing app, confirms to `VGSCheckoutBasicConfigurationProtocol`.
public struct VGSCheckoutMultiplexingPaymentConfiguration: VGSCheckoutBasicConfigurationProtocol, VGSCheckoutMultiplexingBasicConfiguration {

	/// A callback to be run with a `VGSCheckoutMultiplexingPaymentConfiguration` on configuration setup succeed.
	/// - Parameters:
	///   - configuration:  `VGSCheckoutMultiplexingPaymentConfiguration` object, configuration.
	public typealias CreateConfigurationSuccessCompletion = (_ configuration: inout VGSCheckoutMultiplexingPaymentConfiguration) -> Void

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

	/// Holds multiplexing payment info.
	internal let paymentInfo: VGSMultiplexingPaymentInfo

	/// Payment orchestration access token.
	private(set) public var accessToken: String

	// MARK: - Public

	/// Creates Multiplexing Payment config.
	/// - Parameters:
	///   - accessToken: `String` object, should be valid access token for payment orchestration.
	///   - orderId: `String` object, orderId for payment orchestration.
	///   - tenantId: `String` object, payment orchestration tenant id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	///   - success: `CreateConfigurationSuccessCompletion` object, callback for configuration setup succeed.
	///   - failure: `CreateConfigurationFailCompletion` object, callback for configuration setup fail.
	public static func createConfiguration(accessToken: String, orderId: String, tenantId: String, environment: String = "sandbox", success: @escaping CreateConfigurationSuccessCompletion, failure: @escaping CreateConfigurationFailCompletion) {
		guard VGSMultiplexingCredentialsValidator.isJWTScopeValid(accessToken, vaultId: tenantId, environment: environment) else {
			let error = NSError(domain: VGSCheckoutErrorDomain, code: VGSErrorType.invalidJWTToken.rawValue, userInfo: [NSLocalizedDescriptionKey: "JWT token is invalid or empty!"])
			failure(error as Error)
			return
		}

		let vgsCollect = VGSCollect(id: tenantId, environment: environment)
		let orderAPIWorker = VGSMultiplexingPaymentOrderAPIWorker(vgsCollect: vgsCollect, accessToken: accessToken)
		orderAPIWorker.fetchPaymentConfiguration(for: orderId) { paymentInfo in
			print("succcess")
			var paymentCardConfiguration = VGSCheckoutMultiplexingPaymentConfiguration(accessToken: accessToken, orderId: orderId, paymentInfo: paymentInfo, tenantId: tenantId, environment: environment)
			success(&paymentCardConfiguration)
		} failure: { error in
			failure(error)
		}
	}

	// MARK: - Initialization

	/// Configuration initializer.
	/// - Parameters:
	///   - accessToken: `String` object, should be valid access token for payment orchestration.
	///   - orderId: `String` object, should be valid orderId for payment orchestration.
	///   - paymentInfo: `VGSMultiplexingPaymentInfo` object, payment info.
	///   - tenantId: `String` object, payment orchestration tenant id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	internal init(accessToken: String, orderId: String, paymentInfo: VGSMultiplexingPaymentInfo, tenantId: String, environment: String = "sandbox") {
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
  public var saveCardOptionEnabled: Bool {
    get {
      return formConfiguration.showSaveCardOption
    }
    set {
      formConfiguration.showSaveCardOption = newValue
    }
  }

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

	/// An array of financial instruments ids representing saved cards.
	internal var savedPaymentCardsIds: [String] = []

	// MARK: - Internal

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
