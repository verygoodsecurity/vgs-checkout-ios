//
//  VGSCheckoutBasicConfigurationProtocol.swift
//  VGSCheckout
//

import Foundation

/// VGSCheckout basic configuration.
public protocol VGSCheckoutBasicConfigurationProtocol {}

/// Internal protocol for VGSCheckout configuration.
internal protocol VGSCheckoutConfigurationProtocol: VGSCheckoutBasicConfigurationProtocol {

	/// Payment flow type.
	var paymentFlowType: VGSCheckoutPaymentFlowType {get}
}

/// Defines payment flow types.
internal enum VGSCheckoutPaymentFlowType {

	/// Use regular vault flow.
	case vault

	/// Use multiplexing flow for payment optimization.
	case multiplexing
}

internal enum VGSPaymentFlow {
	case vault(_ configuration: VGSCheckoutVaultConfiguration)

	/// case multiplexing

	init?(configuration: VGSCheckoutBasicConfigurationProtocol) {
		guard let checkoutConfiguration = configuration as? VGSCheckoutConfigurationProtocol else {
			return nil
		}

		switch checkoutConfiguration.paymentFlowType {
		case .vault:
			if let vaultConfig = checkoutConfiguration as? VGSCheckoutVaultConfiguration {
				self = .vault(vaultConfig)
				return
			} else {
				return nil
			}
		case .multiplexing:
			break
		}

		return nil
	}
}
