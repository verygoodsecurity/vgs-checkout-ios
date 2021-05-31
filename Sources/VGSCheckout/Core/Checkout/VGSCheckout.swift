//
//  VGSCheckout.swift
//  VGSCheckout

import Foundation
#if os(iOS)
import UIKit
#endif
import VGSCollectSDK

/// A drop-in class that presents a checkout form for a customer to complete payment.
public class VGSCheckout {

	/// Defines checkout flows (internal for now).
	internal enum CheckoutFlow {

		/// Pay with card.
		case card
	}

	/// Checkout configuration.
	internal let configurationType: VGSPaymentFlowConfigurationType

	internal let vgsCollect: VGSCollect

	// MARK: - Initialization

	/// Initialization.
	/// - Parameter configuration: `VGSCheckoutBasicConfigurationProtocol` object, should confirm to `VGSCheckoutBasicConfigurationProtocol` and hold valid checkout configuration.
	public init?(configuration: VGSCheckoutBasicConfigurationProtocol) {

		guard let checkoutConfigurationType = VGSPaymentFlowConfigurationType(configuration: configuration) else {
			assertionFailure("VGSCheckout critical error! Unsupported configuration!")
			return nil
		}

		self.configurationType = checkoutConfigurationType

		let hostNamePolicy = self.checkoutConfiguration.routeConfiguration.hostnamePolicy
		let collectConfig = checkoutConfiguration.collectConfig
		switch hostNamePolicy {
		case .vault:
			self.vgsCollect = VGSCollect(id: collectConfig.vaultID, environment: collectConfig.environment)
		case .customHostname(let customHostname):
			self.vgsCollect = VGSCollect(id: collectConfig.vaultID, environment: collectConfig.environment, hostname: customHostname)
		case .local(let satelliteConfiguration):
			self.vgsCollect = VGSCollect(id: collectConfig.vaultID, environment: collectConfig.environment, hostname: satelliteConfiguration.localhost, satellitePort: satelliteConfiguration.port)
		}
	}

	// MARK: - Interface

	/// Present drop-in checkout.
	/// - Parameter viewController: `UIViewController` object, view controller to present checkout from.
	/// - Parameter animated: `Bool` object, boolean flag indicating whether controller should be presented with animation, default is `true`.
	public func present(from viewController: UIViewController, animated: Bool = true) {
		presentPayment(from: viewController, animated: animated, flow: CheckoutFlow.card)
	}

	// MARK: - Helpers

	internal func presentPayment(from viewController: UIViewController, animated: Bool, flow: CheckoutFlow) {

	}
}

internal extension VGSCollect {
	init(hostnamePolicy: VGSPaymentFlowConfigurationType) {
		
		switch hostNamePolicy {
		case .vault:
			self.vgsCollect = VGSCollect(id: collectConfig.vaultID, environment: collectConfig.environment)
		case .customHostname(let customHostname):
			self.vgsCollect = VGSCollect(id: collectConfig.vaultID, environment: collectConfig.environment, hostname: customHostname)
		case .local(let satelliteConfiguration):
			self.vgsCollect = VGSCollect(id: collectConfig.vaultID, environment: collectConfig.environment, hostname: satelliteConfiguration.localhost, satellitePort: satelliteConfiguration.port)
		}
	}
}
