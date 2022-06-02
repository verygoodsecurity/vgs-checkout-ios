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
	 Request was submitted with result.

	 - Parameters:
			- result: request result of checkout save card flow.
	*/
	case requestSubmitted(_ result: VGSCheckoutRequestResult)

	/// User cancelled checkout flow.
	case cancelled

	/**
	 Remove card request was sumitted with result.

	 - Parameters:
	    - id: `String` object, removed card financial instrument id.
			- result: `VGSCheckoutRequestResult`, request result of checkout save card flow.
	*/
	case removeSaveCardDidFinish(_ id: String, _ result: VGSCheckoutRequestResult)

//	/// User pressed pay button with saved card.
//	case payWithSavedCard(_ id: String)

	/**
	 Checkout did finish with payment method.

	 - Parameters:
			- paymentMethod: `VGSCheckoutPaymentMethod` object, payment method.
	*/
	case checkoutDidFinish(_ paymentMethod: VGSCheckoutPaymentMethod)

	case checkoutTransferDidCreateNewCard(_ newCardInfo: VGSCheckoutNewPaymentCardInfo, _ result: VGSCheckoutRequestResult)
}

/// Handles `Save card` use case logic for custom configuration.
internal class VGSSaveCardCheckoutService: NSObject, VGSCheckoutServiceProtocol {

	/// An object that acts as a delegate for Core `VGSCheckout` instance.
	internal weak var serviceDelegate: VGSCheckoutServiceDelegateProtocol?

	/// Checkout configuration type.
	internal let checkoutConfigurationType: VGSCheckoutConfigurationType

	/// Add card configuration.
	internal var configuration: VGSCheckoutCustomConfiguration {
		switch checkoutConfigurationType {
		case .custom(let configuration):
			return configuration
		default:
			fatalError("invalid configuration for save card custom config flow!")
		}
	}

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
