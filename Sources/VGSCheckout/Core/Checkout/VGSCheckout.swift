//
//  VGSCheckout.swift
//  VGSCheckout

import Foundation
#if os(iOS)
import UIKit
#endif

/// A drop-in class that presents a checkout form for financial operations: add card, payment processing etc.
public class VGSCheckout {

	/// An object that acts as a `VGSCheckout` delegate.
	public weak var delegate: VGSCheckoutDelegate?

	/// Checkout coordinator.
	fileprivate var checkoutCoordinator = VGSCheckoutFlowCoordinator()

	/// Handles add card flow.
	internal let addCardUseCaseManager: VGSAddCardUseCaseManager

	// MARK: - Initialization

	/// Initialization.
	/// - Parameters:
	///   - configuration: `VGSCheckoutConfigurationProtocol` object, should be valid checkout configuration.
	public init(configuration: VGSCheckoutConfigurationProtocol) {
		guard let paymentInstrument = VGSPaymentInstrument(configuration: configuration) else {
			fatalError("VGSCheckout critical error! Unsupported configuration!")
		}

		let vgsCollect = VGSCollect(vaultID: configuration.vaultID, environment: configuration.environment, paymentFlow: paymentInstrument)
    self.addCardUseCaseManager = VGSAddCardUseCaseManager(paymentInstrument: paymentInstrument, vgsCollect: vgsCollect, uiTheme: configuration.uiTheme)
		addCardUseCaseManager.delegate = self
	}

	// MARK: - Interface

	/// Present drop-in checkout.
	/// - Parameter viewController: `UIViewController` object, view controller to present checkout.
	/// - Parameter theme: `Any` object. Theme for UI configuration will be used here. Empty object for now.
	/// - Parameter animated: `Bool` object, boolean flag indicating whether controller should be presented with animation, default is `true`.
	public func present(from viewController: UIViewController, theme: Any? = nil, animated: Bool = true) {

		let checkoutViewController = addCardUseCaseManager.buildCheckoutViewController()
		checkoutCoordinator.setRootViewController(checkoutViewController)
		checkoutViewController.modalPresentationStyle = .overFullScreen

		viewController.present(checkoutViewController, animated: animated, completion: nil)
	}
}

// MARK: - VGSAddCardUseCaseManagerDelegate

extension VGSCheckout: VGSAddCardUseCaseManagerDelegate {
	func addCardFlowDidChange(with state: VGSAddCardFlowState, in useCaseManager: VGSAddCardUseCaseManager) {
		switch state {
		case .cancelled:
			checkoutCoordinator.dismissRootViewController(with: {
				self.delegate?.checkoutDidCancel()
			})
		case .requestSubmitted(let requestResult):
			checkoutCoordinator.dismissRootViewController {
				self.delegate?.checkoutDidFinish(with: requestResult)
			}
		}
	}
}
