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

	/// `String` object, organization vault id.
	internal let vaultID: String

	/// `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox").
	internal let environment: String

//	internal let checkoutFormController: VGSCheckoutFormController

	// MARK: - Initialization

	/// Initialization.
	/// - Parameters:
	///   - vaultID: `String` object, organization vault id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox").
	public init(vaultID: String, environment: String) {
		self.vaultID = vaultID
		self.environment = environment
	}

	// MARK: - Interface

	/// Present drop-in checkout.
	/// - Parameter configuration: `VGSCheckoutBasicConfigurationProtocol` object, should be valid configuration.
	/// - Parameter viewController: `UIViewController` object, view controller to present checkout from.
	/// - Parameter animated: `Bool` object, boolean flag indicating whether controller should be presented with animation, default is `true`.
	public func present(with configuration: VGSCheckoutBasicConfigurationProtocol, from viewController: UIViewController, animated: Bool = true) {
		guard let checkoutPaymentFlow = VGSPaymentFlow(configuration: configuration) else {
			assertionFailure("VGSCheckout critical error! Unsupported configuration!")
			return
		}
		let vgsCollect = VGSCollect(vaultID: vaultID, environment: environment, paymentFlow: checkoutPaymentFlow)
		let checkoutController = VGSCheckoutFormController(paymentFlow: checkoutPaymentFlow, vgsCollect: vgsCollect)
		let checkoutViewController = checkoutController.buildCheckoutViewController()
		checkoutViewController.modalPresentationStyle = .overFullScreen
		viewController.present(checkoutViewController, animated: animated, completion: nil)
	}
}

internal extension VGSCollect {
	convenience init(vaultID: String, environment: String, paymentFlow: VGSPaymentFlow) {
		switch paymentFlow {
		case .vault(let configuration):
			let hostNamePolicy = configuration.requestConfiguration.hostnamePolicy
			switch hostNamePolicy {
			case .vault:
				self.init(id: vaultID, environment: environment)
			case .customHostname(let customHostname):
				self.init(id: vaultID, environment: environment, hostname: customHostname)
			case .local(let satelliteConfiguration):
				self.init(id: vaultID, environment: environment, hostname: satelliteConfiguration.localhost, satellitePort: satelliteConfiguration.port)
			}
		}
	}
}
