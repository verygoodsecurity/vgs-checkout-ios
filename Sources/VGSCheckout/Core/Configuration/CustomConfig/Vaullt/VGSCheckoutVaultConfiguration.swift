//
//  VGSCheckoutVaultConfiguration.swift
//  VGSCheckout

import Foundation

/// Holds configuration for vault, confirms to `VGSCheckoutConfigurationProtocol`.
public struct VGSCheckoutVaultConfiguration: VGSCheckoutConfigurationProtocol {

	/// Payment flow type.
	internal let paymentFlowType: VGSCheckoutPaymentFlowType = .vault

	/// Inbound rout path for your organization vault.
	public let path: String

	/// Card details options. Check `VGSCheckoutCardDetailsOptions` for default options.
	public var cardDetailsOptions: VGSCheckoutCardDetailsOptions = VGSCheckoutCardDetailsOptions()

	/// Request configuration, default is `VGSCheckoutRequestConfiguration` object.
	public var requestConfiguration: VGSCheckoutRequestConfiguration = VGSCheckoutRequestConfiguration()

	/// Initialization.
	/// - Parameters:
	///   - path: `String` object, inbound rout path for your organization vault.
	///   - cardDetailsOptions: `VGSCheckoutCardDetailsOptions`, card details options. Check `VGSCheckoutCardDetailsOptions` for default options.
	///   - routeConfiguration: `VGSCheckoutRequestConfiguration`, default is `VGSCheckoutRequestConfiguration` object.
	public init(path: String, cardDetailsOptions: VGSCheckoutCardDetailsOptions = VGSCheckoutCardDetailsOptions(), requestConfiguration: VGSCheckoutRequestConfiguration = VGSCheckoutRequestConfiguration()) {
		self.path = path
		self.cardDetailsOptions = cardDetailsOptions
		self.requestConfiguration = requestConfiguration
	}
}
