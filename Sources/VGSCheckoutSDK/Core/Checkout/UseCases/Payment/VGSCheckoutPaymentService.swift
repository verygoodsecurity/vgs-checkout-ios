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

	/// Pay opt configuration.
	internal var configuration: VGSCheckoutPaymentConfiguration {
		switch checkoutConfigurationType {
		case .payoptTransfers(let payOptConfiguration):
			return payOptConfiguration
		default:
			fatalError("invalid configuration for pay opt transfers flow!")
		}
	}

	/// `VGSCollect` object.
	internal let vgsCollect: VGSCollect

	/// UI Theme.
	internal let uiTheme: VGSCheckoutThemeProtocol

	// MARK: - Initialization

	/// Initializer.
	/// - Parameters:
	///   - checkoutConfigurationType: `VGSCheckoutConfigurationType` object, configuration type.
	///   - vgsCollect: `VGSCollect` object, collect object.
	///   - uiTheme: `VGSCheckoutThemeProtocol` object, ui theme.
	required init(checkoutConfigurationType: VGSCheckoutConfigurationType, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol) {
		self.checkoutConfigurationType = checkoutConfigurationType
		self.vgsCollect = vgsCollect
		self.uiTheme = uiTheme
		//		self.initialScreen = .payWithNewCard
		switch checkoutConfigurationType {
		case .payoptTransfers(let configuration):
			if !configuration.savedCards.isEmpty {
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
		let vc: UIViewController
		switch initialScreen {
		case .payWithNewCard:
			vc = buildPayWithNewCardVC()
		case .paymentOptions:
			//			fatalError("not implemented")
			vc = buildPaymentOptionsVC()
		}
		return UINavigationController(rootViewController: vc)
	}

	/// Builds payment options screen.
	/// Returns: `UIViewController` object, view controller for payment options.
	internal func buildPaymentOptionsVC() -> UIViewController {
		let paymentOptionsVC = VGSPaymentOptionsViewController(paymentService: self)

		return paymentOptionsVC
	}

	/// Builds pay with new card vc.
	/// Returns: `UIViewController` object, view controller for pay with new card.
	internal func buildPayWithNewCardVC() -> UIViewController {
		let payWithNewCardVC = VGSPayWithCardViewController(paymentService: self, initialScreen: .payWithNewCard)

		return payWithNewCardVC
	}
}
