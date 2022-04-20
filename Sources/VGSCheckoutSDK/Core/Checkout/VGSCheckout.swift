//
//  VGSCheckoutSDK.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// A drop-in class that presents a checkout form for financial operations: add card, payment processing etc.
public class VGSCheckout {

	/// An object that acts as a `VGSCheckout` delegate.
	public weak var delegate: VGSCheckoutDelegate?

	/// Checkout coordinator.
	internal var checkoutCoordinator: VGSCheckoutFlowCoordinator?

	/// Payment instrument.
	internal let checkoutConfigurationType: VGSCheckoutConfigurationType

	/// VGS collect.
	internal let vgsCollect: VGSCollect

	/// UI Theme.
	internal let uiTheme: VGSCheckoutThemeProtocol

	// MARK: - Initialization

	/// Initialization.
	/// - Parameters:
	///   - configuration: `VGSCheckoutConfigurationProtocol` object, should be valid checkout configuration.
	public init(configuration: VGSCheckoutConfigurationProtocol) {
		guard let checkoutConfigurationType = VGSCheckoutConfigurationType(configuration: configuration) else {
			fatalError("VGSCheckout critical error! Unsupported configuration!")
		}

		self.checkoutConfigurationType = checkoutConfigurationType
		vgsCollect = VGSCollect(vaultID: checkoutConfigurationType.mainCheckoutId, environment: configuration.environment, paymentFlow: checkoutConfigurationType)
		self.uiTheme = configuration.uiTheme
	}

	// MARK: - Interface

	/// Present drop-in checkout.
	/// - Parameters:
	///   -  viewController: `UIViewController` object, view controller to present checkout.
	///   -  animated: `Bool` object, boolean flag indicating whether controller should be presented with animation, default is `true`.
	public func present(from viewController: UIViewController, animated: Bool = true) {

		self.checkoutCoordinator = VGSCheckoutFlowCoordinator(checkoutConfigurationType: checkoutConfigurationType, vgsCollect: vgsCollect, uiTheme: uiTheme)
		var currectCheckoutService = checkoutCoordinator?.checkoutServiceProvider.checkoutService

		currectCheckoutService?.serviceDelegate = self

		let checkoutViewController = checkoutCoordinator?.checkoutServiceProvider.checkoutService.buildCheckoutViewController()

		if let vc = checkoutViewController {
			checkoutCoordinator?.setRootViewController(vc)
			vc.modalPresentationStyle = .overFullScreen
			viewController.present(vc, animated: animated, completion: nil)
		}
	}
}

// MARK: - VGSCheckoutServiceDelegateProtocol

/// no:doc
extension VGSCheckout: VGSCheckoutServiceDelegateProtocol {

	/// Handles changes in checkout service state.
	/// - Parameters:
	///   - state: `VGSAddCardFlowState` object, checkout service state.
	///   - service: `VGSCheckoutServiceProtocol` object, checkout service.
	func checkoutServiceStateDidChange(with state: VGSAddCardFlowState, in service: VGSCheckoutServiceProtocol) {

		guard let coordintator = checkoutCoordinator else {return}
		switch state {
		case .cancelled:
			coordintator.dismissRootViewController(with: {
				// Close checkout.
				self.delegate?.checkoutDidCancel()
			})
		case .requestSubmitted(let requestResult):
				switch requestResult {
				case .success:
					coordintator.dismissRootViewController {
						// Close checkout with success request result.
						self.delegate?.checkoutDidFinish(with: requestResult)
					}
				case .failure(_, _, _, let error, _):
					coordintator.dismissRootViewController {
						// Close checkout with success request result.
						self.delegate?.checkoutDidFinish(with: requestResult)
					}
			 }
		case .removeSaveCardDidFinish(let id, let result):
			self.delegate?.removeCardDidFinish(with: id, result: result)
		case .checkoutDidFinish(let paymentMethod):
			coordintator.dismissRootViewController {[weak self] in
				guard let strongSelf = self else {return}
        
        /// Analytics
        var extraData = [String: Any]()
        switch paymentMethod {
        case .newCard(_, _):
          extraData["paymentMethod"] = "newCard"
        case .savedCard(_):
          extraData["paymentMethod"] = "savedCard"
        }
        VGSCheckoutAnalyticsClient.shared.trackFormEvent(strongSelf.vgsCollect.formAnalyticsDetails, type: .paymentMethodChoice, status: .success, extraData: extraData)
        
				strongSelf.delegate?.checkoutDidFinish(with: paymentMethod)
			}
		}
	}
}
