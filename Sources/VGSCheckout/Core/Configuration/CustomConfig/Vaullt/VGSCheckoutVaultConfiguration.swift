//
//  VGSCheckoutVaultConfiguration.swift
//  VGSCheckout

import Foundation

/// Holds configuration for vault, confirms to `VGSCheckoutConfigurationProtocol`.
public struct VGSCheckoutVaultConfiguration: VGSCheckoutConfigurationProtocol {

	/// `String` object, organization vault id.
	public let vaultID: String

	/// `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox").
	public let environment: String

	/// Inbound rout path for your organization vault.
	public let path: String

	/// Card details options. Check `VGSCheckoutCardDetailsOptions` for default options.
	public var cardDetailsOptions: VGSCheckoutCardDetailsOptions = VGSCheckoutCardDetailsOptions()

	/// Route configuration, default is `VGSCheckoutRouteConfiguration` object.
	public var routeConfiguration: VGSCheckoutRequestConfiguration = VGSCheckoutRouteConfiguration()

	/// Initialization.
	/// - Parameters:
	///   - vaultID: `String` object, organization vault id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox").
	///   - path: `String` object, inbound rout path for your organization vault.
	///   - cardDetailsOptions: `VGSCheckoutCardDetailsOptions`, card details options. Check `VGSCheckoutCardDetailsOptions` for default options.
	///   - routeConfiguration: `VGSCheckoutRouteConfiguration`, default is `VGSCheckoutRouteConfiguration` object.
	public init(vaultID: String, environment: String, path: String, cardDetailsOptions: VGSCheckoutCardDetailsOptions = VGSCheckoutCardDetailsOptions(), routeConfiguration: VGSCheckoutRequestConfiguration = VGSCheckoutRouteConfiguration()) {
		self.vaultID = vaultID
		self.environment = environment
		self.path = path
		self.cardDetailsOptions = cardDetailsOptions
		self.routeConfiguration = routeConfiguration
	}
}
