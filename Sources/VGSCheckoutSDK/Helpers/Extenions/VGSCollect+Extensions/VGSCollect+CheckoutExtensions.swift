//
//  VGSCollect+CheckoutExtensions.swift
//  VGSCheckoutSDK

import Foundation

internal extension VGSCollect {
	/// Convenience init for `VGSCollect`.
	/// - Parameters:
	///   - vaultID: `String` object, organization vault id.
	///   - environment: environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
  ///  - routeId: `String?`, organization vault inbound route id, could be `nil`.
	///   - paymentFlow: `VGSPaymentProcessingFlow` object.
  convenience init(vaultID: String, environment: String, routeId: String?, paymentFlow: VGSCheckoutConfigurationType) {
		switch paymentFlow {
		case .custom(let configuration):
			let hostNamePolicy = configuration.routeConfiguration.hostnamePolicy
			switch hostNamePolicy {
			case .vault:
				self.init(id: vaultID, environment: environment, routeId: routeId)
			case .customHostname(let customHostname):
				self.init(id: vaultID, environment: environment, routeId: routeId, hostname: customHostname)
//			case .local(let localhost, let port):
//				self.init(id: vaultID, environment: environment, hostname: localhost, satellitePort: port)
			}
		case .payoptAddCard, .payoptTransfers:
			self.init(id: vaultID, environment: environment, routeId: routeId)
		}
	}
}
