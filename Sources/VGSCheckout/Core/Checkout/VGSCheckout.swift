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

	/// `String` object, organization vault id.
	internal let vaultID: String

	/// `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox").
	internal let environment: String

	// MARK: - Initialization

	/// Initialization.
	/// - Parameters:
	///   - vaultID: `String` object, organization vault id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	public init(vaultID: String, environment: String = "sandbox") {
		self.vaultID = vaultID
		self.environment = environment
	}

	/// We need to keep a reference to the instance
	internal var checkoutFormController: VGSCheckoutFormController?

	// MARK: - Interface

	/// Present drop-in checkout.
	/// - Parameter configuration: `VGSCheckoutConfigurationProtocol` object, should be valid configuration.
	/// - Parameter viewController: `UIViewController` object, view controller to present checkout.
	/// - Parameter theme: `Any` object. Theme for UI configuration will be used here. Empty object for now.
	/// - Parameter animated: `Bool` object, boolean flag indicating whether controller should be presented with animation, default is `true`.
	public func present(with configuration: VGSCheckoutConfigurationProtocol, from viewController: UIViewController, theme: Any? = nil, animated: Bool = true) {
		guard let checkoutPaymentFlow = VGSPaymentInstrument(configuration: configuration) else {
			assertionFailure("VGSCheckout critical error! Unsupported configuration!")
			return
		}
		let vgsCollect = VGSCollect(vaultID: vaultID, environment: environment, paymentFlow: checkoutPaymentFlow)

		checkoutFormController = VGSCheckoutFormController(paymentInstrument: checkoutPaymentFlow, vgsCollect: vgsCollect)

		let checkoutViewController = checkoutFormController?.buildCheckoutViewController()
		checkoutViewController?.modalPresentationStyle = .overFullScreen
		viewController.present(checkoutViewController!, animated: animated, completion: nil)
	}
}

internal extension VGSCollect {
	/// Convenience init for `VGSCollect`.
	/// - Parameters:
	///   - vaultID: `String` object, organization vault id.
	///   - environment: environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	///   - paymentFlow: `VGSPaymentProcessingFlow` object.
	convenience init(vaultID: String, environment: String, paymentFlow: VGSPaymentInstrument) {
		switch paymentFlow {
		case .vault(let configuration):
			let hostNamePolicy = configuration.routeConfiguration.hostnamePolicy
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
