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

	/// Payment flow type.
	internal let paymentFlow: VGSPaymentFlow

	/// VGSCollect instance.
	internal let vgsCollect: VGSCollect

	// MARK: - Initialization

	/// Initialization.
	/// - Parameter configuration: `VGSCheckoutBasicConfigurationProtocol` object, should confirm to `VGSCheckoutBasicConfigurationProtocol` and hold valid checkout configuration.
	public init?(configuration: VGSCheckoutBasicConfigurationProtocol) {

		guard let checkoutPaymentFlow = VGSPaymentFlow(configuration: configuration) else {
			assertionFailure("VGSCheckout critical error! Unsupported configuration!")
			return nil
		}

		self.paymentFlow = checkoutPaymentFlow
		self.vgsCollect = VGSCollect(paymentFlow: checkoutPaymentFlow)
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
	convenience init(paymentFlow: VGSPaymentFlow) {
		switch paymentFlow {
		case .vault(let configuration):
			let hostNamePolicy = configuration.requestConfiguration.hostnamePolicy
			switch hostNamePolicy {
			case .vault:
				self.init(id: configuration.vaultID, environment: configuration.environment)
			case .customHostname(let customHostname):
				self.init(id: configuration.vaultID, environment: configuration.environment, hostname: customHostname)
			case .local(let satelliteConfiguration):
				self.init(id: configuration.vaultID, environment: configuration.environment, hostname: satelliteConfiguration.localhost, satellitePort: satelliteConfiguration.port)
			}
		}
	}
}
