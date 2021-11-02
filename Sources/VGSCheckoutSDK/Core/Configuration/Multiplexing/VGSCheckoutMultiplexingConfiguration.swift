//
//  VGSCheckoutSDKMultiplexingConfiguration.swift
//  VGSCheckoutSDK

import Foundation

/// Holds configuration with predefined setup for work with payment orchestration/multiplexing app, confirms to `VGSCheckoutBasicConfigurationProtocol`.
public struct VGSCheckoutMultiplexingConfiguration: VGSCheckoutBasicConfigurationProtocol {

  // MARK: - Attributes
  
	/// `String` object, organization vault id.
	public let vaultID: String

	/// `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	public let environment: String

	/// Multiplexing app access token.
	private(set) public var token: String

  // MARK: - Initialization
  
	/// Configuration initializer (failable).
	/// - Parameters:
  ///   - token: `String` object, should be valid access token for multiplexing app.
	///   - vaultID: `String` object, organization vault id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	public init?(token: String, vaultID: String, environment: String = "sandbox") {
		guard VGSMultiplexingCredentialsValidator.isJWTScopeValid(token, vaultId: vaultID, environment: environment) else {
            return nil
        }
    self.token = token
		self.vaultID = vaultID
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

  // MARK: - Internal
  
	/// Payment flow type (internal use only).
	internal let paymentFlowType: VGSPaymentFlowIdentifier = .multiplexing
  
  /// Form configuration options. Check `VGSCheckoutMultiplexingFormConfiguration` for default settings.
  internal var formConfiguration = VGSMultiplexingFormConfiguration()
}
