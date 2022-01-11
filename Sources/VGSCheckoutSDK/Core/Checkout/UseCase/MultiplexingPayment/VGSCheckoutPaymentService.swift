//
//  VGSPaymentCheckoutService.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Handles `Pay with card` use case logic.
internal class VGSCheckoutPaymentService: NSObject, VGSCheckoutServiceProtocol {

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
		switch checkoutConfigurationType {
		case .multiplexingPayment(let configuration):
			let saveCardViewController = VGSPayWithCardViewController(paymentService: self, initialScreen: .payWithNewCard)
			let navigationController = UINavigationController(rootViewController: saveCardViewController)
			return navigationController


//			if configuration.savedPaymentCardsIds.isEmpty {
//				let saveCardViewController = VGSPayWithCardViewController(paymentService: self, initialScreen: .payWithNewCard)
//				let navigationController = UINavigationController(rootViewController: saveCardViewController)
//
//				return navigationController
//			} else {
//				let paymentOptionsVC = VGSPaymentOptionsViewController(paymentService: self)
//				let navigationController = UINavigationController(rootViewController: paymentOptionsVC)
//
//				return navigationController
//			}
		default:
			fatalError("wrong flow")
		}
	}
}
