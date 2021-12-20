//
//  VGSCollect+CheckoutExtensions.swift
//  VGSCheckoutSDK

import Foundation

internal extension VGSCollect {
	/// Convenience init for `VGSCollect`.
	/// - Parameters:
	///   - vaultID: `String` object, organization vault id.
	///   - environment: environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	///   - paymentFlow: `VGSPaymentProcessingFlow` object.
	convenience init(vaultID: String, environment: String, paymentFlow: VGSCheckoutConfigurationType) {
		switch paymentFlow {
		case .custom(let configuration):
			let hostNamePolicy = configuration.routeConfiguration.hostnamePolicy
			switch hostNamePolicy {
			case .vault:
				self.init(id: vaultID, environment: environment)
			case .customHostname(let customHostname):
				self.init(id: vaultID, environment: environment, hostname: customHostname)
			case .local(let localhost, let port):
				self.init(id: vaultID, environment: environment, hostname: localhost, satellitePort: port)
			}
		case .multiplexingAddCard, .multiplexingPayment:
			self.init(id: vaultID, environment: environment)
		}
	}
}
