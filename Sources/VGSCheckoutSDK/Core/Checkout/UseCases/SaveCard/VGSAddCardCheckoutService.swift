//
//  VGSAddCardCheckoutService.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Defines Add Card use case states.
internal enum VGSAddCardFlowState {

	/**
	 Request was sumitted with result.

	 - Parameters:
			- result: request result of checkout save card flow.
	*/
	case requestSubmitted(_ result: VGSCheckoutRequestResult)

	/// User cancelled checkout flow.
	case cancelled

	/// Save card success on transfer.
	case saveCardDidSuccess(_ data: Data?, _ response: URLResponse?)

	/// Saved card was removed by user from payment options list.
	case savedCardDidRemove(_ id: String)
}

/// Handles `Save card` use case logic.
internal class VGSSaveCardCheckoutService: NSObject, VGSCheckoutServiceProtocol {

	/// An object that acts as a delegate for Core `VGSCheckout` instance.
	internal weak var serviceDelegate: VGSCheckoutServiceDelegateProtocol?

	/// Checkout configuration type.
	internal let checkoutConfigurationType: VGSCheckoutConfigurationType

	/// `VGSCollect` object.
	internal let vgsCollect: VGSCollect

	/// UI Theme.
	internal let uiTheme: VGSCheckoutThemeProtocol

	// MARK: - Initialization

	required init(checkoutConfigurationType: VGSCheckoutConfigurationType, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol) {
		self.checkoutConfigurationType = checkoutConfigurationType
		self.vgsCollect = vgsCollect
		self.uiTheme = uiTheme
	}

	/// Builds view controller for save card flow.
	/// - Returns: `UIViewController` object, view controller with save card form.
	internal func buildCheckoutViewController() -> UIViewController {
		let saveCardViewController = VGSSaveCardViewController(saveCardService: self)
		let navigationController = UINavigationController(rootViewController: saveCardViewController)

		return navigationController
	}
}
