//
//  VGSCheckoutPayoptTransfersService.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Handles `Pay with card` use case logic.
internal class VGSCheckoutPayoptTransfersService: NSObject, VGSCheckoutServiceProtocol {

	/// Initial screen for transfer flow.
	enum InitialScreen {

		/// Payment options.
		case paymentOptions

		/// Pay with new card.
		case payWithNewCard
	}

	/// Initial screen.
	internal let initialScreen: InitialScreen

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
		switch checkoutConfigurationType {
			case .payoptTransfers(let configuration):
				if configuration.savedCards.isEmpty {
					self.initialScreen = .payWithNewCard
				} else {
					self.initialScreen = .paymentOptions
				}
			default:
				fatalError("wrong flow")
			}
	}

	/// Builds view controller for save card flow.
	/// - Returns: `UIViewController` object, view controller with save card form.
	internal func buildCheckoutViewController() -> UIViewController {
		switch initialScreen {
		case .payWithNewCard:
			return buildPayWithNewCardVC()
		case .paymentOptions:
			return buildPaymentOptionsVC()
		}
	}

	/// Builds payment options screen.
	internal func buildPaymentOptionsVC() -> UIViewController {
		let paymentOptionsVC = VGSPaymentOptionsViewController(paymentService: self)

		return paymentOptionsVC
	}

	/// Builds pay with new card vc.
	internal func buildPayWithNewCardVC() -> UIViewController {
		let payWithNewCardVC = VGSPayWithCardViewController(paymentService: self, initialScreen: .payWithNewCard)

		return payWithNewCardVC
	}
}
