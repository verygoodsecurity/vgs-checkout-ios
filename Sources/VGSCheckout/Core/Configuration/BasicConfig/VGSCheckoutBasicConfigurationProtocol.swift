//
//  VGSCheckoutBasicConfigurationProtocol.swift
//  VGSCheckout
//

import Foundation

/// VGSCheckout configuration, public interface.
public protocol VGSCheckoutConfigurationProtocol {}

/// Internal protocol for VGSCheckout configuration.
internal protocol VGSCheckoutBasicConfigurationProtocol: VGSCheckoutConfigurationProtocol {

	/// Payment flow type.
	var paymentFlowType: VGSPaymentFlowIdentifier {get}
}

/// Defines payment flow identifiers.
internal enum VGSPaymentFlowIdentifier {

	/// Use regular vault flow.
	case vault

	/// Use multiplexing flow for payment optimization.
	case multiplexing
}

/// Defines paymnet processing flow.
internal enum VGSPaymentProcessingFlow {

	case vault(_ configuration: VGSCheckoutVaultConfiguration)

	/// case multiplexing

	init?(configuration: VGSCheckoutConfigurationProtocol) {
		guard let checkoutConfiguration = configuration as? VGSCheckoutBasicConfigurationProtocol else {
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
