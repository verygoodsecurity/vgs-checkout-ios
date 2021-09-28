//
//  VGSCheckoutSDKMultiplexingConfiguration.swift
//  VGSCheckoutSDK

import Foundation

/// Holds configuration for multiplexing payment processing, confirms to `VGSCheckoutBasicConfigurationProtocol`.
public struct VGSCheckoutMultiplexingConfiguration: VGSCheckoutBasicConfigurationProtocol {

	/// `String` object, organization vault id.
	public let vaultID: String

	/// `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	public let environment: String

	/// Multiplexing token.
	private(set) public var token: String

	/// Configuration initializer (failable).
	/// - Parameters:
	///   - vaultID: `String` object, organization vault id.
	///   - token: `String` object, should be valid token for multiplexing.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	public init?(vaultID: String, token: String, environment: String = "sandbox") {
        guard VGSMultiplexingCredentialsValidator.isJWTScopeValid(token, vaultId: vaultID) else {
            return nil
        }
		self.vaultID = vaultID
		self.token = token
		self.environment = environment
	}

	/// Checkout UI elements  configuration.
	public var uiTheme: VGSCheckoutThemeProtocol = VGSCheckoutDefaultTheme()

	/// Payment flow type (internal use only).
	internal let paymentFlowType: VGSPaymentFlowIdentifier = .multiplexing
}
