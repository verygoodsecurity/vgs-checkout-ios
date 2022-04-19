//
//  VGSPayoptAddCardCheckoutService.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Checkout service for payopt add card configuration.
internal class VGSPayoptAddCardCheckoutService: NSObject, VGSCheckoutServiceProtocol {

	/// Initial screen for transfer flow.
	enum InitialScreen {

		/// Payment options.
		case paymentOptions

		/// Pay with new card.
		case payWithNewCard
	}

	/// An object that acts as a delegate for Core `VGSCheckout` instance.
	internal weak var serviceDelegate: VGSCheckoutServiceDelegateProtocol?

	/// Checkout configuration type.
	internal let checkoutConfigurationType: VGSCheckoutConfigurationType

	/// Add card configuration.
	internal var configuration: VGSCheckoutAddCardConfiguration {
		switch checkoutConfigurationType {
		case .payoptAddCard(let configuration):
			return configuration
		default:
			fatalError("invalid configuration for pay opt config flow!")
		}
	}

	/// `VGSCollect` object.
	internal let vgsCollect: VGSCollect

	/// UI Theme.
	internal let uiTheme: VGSCheckoutThemeProtocol

	/// Initial screen.
	internal let initialScreen: InitialScreen

	/// Initializer.
	/// - Parameters:
	///   - checkoutConfigurationType: `VGSCheckoutConfigurationType` object, configuration type.
	///   - vgsCollect: `VGSCollect` object, collect object.
	///   - uiTheme: `VGSCheckoutThemeProtocol` object, ui theme.
	required init(checkoutConfigurationType: VGSCheckoutConfigurationType, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol) {
		self.checkoutConfigurationType = checkoutConfigurationType
		self.vgsCollect = vgsCollect
		self.uiTheme = uiTheme
		switch checkoutConfigurationType {
		case .payoptAddCard(let configuration):
			if  configuration.savedCards.isEmpty {
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
		let saveCardViewController = VGSPayWithCardViewController(paymentService: self, initialScreen: initialScreen)

		return saveCardViewController
	}
}
