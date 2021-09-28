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
	internal var addCardUseCaseManager: VGSAddCardUseCaseManager?

	/// Payment instrument.
	internal let paymentInstrument: VGSPaymentInstrument

	/// VGS collect.
	internal let vgsCollect: VGSCollect

	/// UI Theme.
	internal let uiTheme: VGSCheckoutThemeProtocol

	// MARK: - Initialization

	/// Initialization.
	/// - Parameters:
	///   - configuration: `VGSCheckoutConfigurationProtocol` object, should be valid checkout configuration.
	public init(configuration: VGSCheckoutConfigurationProtocol) {
		guard let paymentInstrument = VGSPaymentInstrument(configuration: configuration) else {
			fatalError("VGSCheckout critical error! Unsupported configuration!")
		}

		self.paymentInstrument = paymentInstrument
		vgsCollect = VGSCollect(vaultID: configuration.vaultID, environment: configuration.environment, paymentFlow: paymentInstrument)
		self.uiTheme = configuration.uiTheme
	}

	// MARK: - Interface

	/// Present drop-in checkout.
	/// - Parameter viewController: `UIViewController` object, view controller to present checkout.
	/// - Parameter animated: `Bool` object, boolean flag indicating whether controller should be presented with animation, default is `true`.
	public func present(from viewController: UIViewController, animated: Bool = true) {

		self.addCardUseCaseManager = VGSAddCardUseCaseManager(paymentInstrument: paymentInstrument, vgsCollect: vgsCollect, uiTheme: uiTheme)
		addCardUseCaseManager?.delegate = self

		let checkoutViewController = addCardUseCaseManager?.buildCheckoutViewController()

		if let vc = checkoutViewController {
			checkoutCoordinator.setRootViewController(vc)
			vc.modalPresentationStyle = .overFullScreen
			viewController.present(vc, animated: animated, completion: nil)
		}
	}
}

// MARK: - VGSAddCardUseCaseManagerDelegate

extension VGSCheckout: VGSAddCardUseCaseManagerDelegate {
	func addCardFlowDidChange(with state: VGSAddCardFlowState, in useCaseManager: VGSAddCardUseCaseManager) {
		switch state {
		case .cancelled:
			checkoutCoordinator.dismissRootViewController(with: {
				// Close checkout.
				self.delegate?.checkoutDidCancel()
			})
		case .requestSubmitted(let requestResult):
				switch requestResult {
				case .success:
					checkoutCoordinator.dismissRootViewController {
						// Close checkout with success request result.
						self.delegate?.checkoutDidFinish(with: requestResult)
					}
				case .failure(_, _, _, let error):
					// Do not close checkout for `noConnection` error.
					if let responseError = error, VGSCheckoutErrorUtils.isNoConnectionError(error), let viewController = checkoutCoordinator.rootController {
						VGSDialogHelper.presentErrorAlertDialog(with: responseError.localizedDescription, in: viewController, completion: {
							// Reset UI state to valid (previous state before submit).
							self.addCardUseCaseManager?.state = .valid
						})
					} else {
						// Close checkout with error request result.
						checkoutCoordinator.dismissRootViewController {
							self.delegate?.checkoutDidFinish(with: requestResult)
						}
					}
			 }
		}
	}
}
