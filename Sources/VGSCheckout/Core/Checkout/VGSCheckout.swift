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

	/// Payment instrument.
	internal let paymentInstrument: VGSPaymentInstrument

	/// Collect instance.
	internal let vgsCollect: VGSCollect

	/// Checkout coordinator.
	fileprivate var checkoutCoordinator = VGSCheckoutFlowCoordinator()

	/// Handles add card flow.
	internal let checkoutFormController: VGSAddCardFormPresenter

	// MARK: - Initialization

	/// Initialization.
	/// - Parameters:
	///   - vaultID: `String` object, organization vault id.
	///   - environment: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox"). Default is `sandbox`.
	///   - configuration: `VGSCheckoutConfigurationProtocol` object, should be valid checkout configuration.
	public init(vaultID: String, environment: String = "sandbox", configuration: VGSCheckoutConfigurationProtocol) {
		guard let paymetInstrument = VGSPaymentInstrument(configuration: configuration) else {
			fatalError("VGSCheckout critical error! Unsupported configuration!")
		}
		self.vaultID = vaultID
		self.environment = environment
		self.paymentInstrument = paymetInstrument
		self.vgsCollect = VGSCollect(vaultID: vaultID, environment: environment, paymentFlow: paymetInstrument)
		self.checkoutFormController = VGSAddCardFormPresenter(paymentInstrument: paymetInstrument, vgsCollect: vgsCollect)
	}

	// MARK: - Interface

	/// Present drop-in checkout.
	/// - Parameter viewController: `UIViewController` object, view controller to present checkout.
	/// - Parameter theme: `Any` object. Theme for UI configuration will be used here. Empty object for now.
	/// - Parameter animated: `Bool` object, boolean flag indicating whether controller should be presented with animation, default is `true`.
	public func present(from viewController: UIViewController, theme: Any? = nil, animated: Bool = true) {

		let checkoutViewController = checkoutFormController.buildCheckoutViewController()
		checkoutCoordinator.setRootViewController(checkoutViewController)
		checkoutViewController.modalPresentationStyle = .overFullScreen

		viewController.present(checkoutViewController, animated: animated, completion: nil)
	}
}
