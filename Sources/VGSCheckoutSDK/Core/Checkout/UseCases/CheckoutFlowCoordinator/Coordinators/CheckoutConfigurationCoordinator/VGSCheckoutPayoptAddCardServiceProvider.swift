//
//  VGSCheckoutPayoptAddCardServiceProvider.swift
//  VGSCheckoutSDK
//

import Foundation
#if os(iOS)
import UIKit
#endif

/// Pay opt add card service provider.
internal final class VGSCheckoutPayoptAddCardServiceProvider: VGSCheckoutServiceProviderProtocol {

	// MARK: - Initializer

	/// Initializer.
	/// - Parameter configuration: `VGSCheckoutAddCardConfiguration` object, payopt add card configuration.
	/// - Parameter vgsCollect: `VGSCollect` object, an instance of `VGSCollect`.
	/// - Parameter uiTheme: `VGSCheckoutThemeProtocol` object, ui theme.
	init(configuration: VGSCheckoutAddCardConfiguration, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol) {
		self.configuration = configuration
		self.vgsCollect = vgsCollect
		self.uiTheme = uiTheme

		guard let checkoutConfigurationType = VGSCheckoutConfigurationType(configuration: configuration) else {
			fatalError("Invalid configuration for payopt add card service provier!")
		}
		self.checkoutService = VGSPayoptAddCardCheckoutService(checkoutConfigurationType: checkoutConfigurationType, vgsCollect: vgsCollect, uiTheme: uiTheme)
	}

	// MARK: - Vars

	/// VGS collect.
	internal let vgsCollect: VGSCollect

	/// UI Theme.
	internal let uiTheme: VGSCheckoutThemeProtocol

	/// Checkout service.
	internal let checkoutService: VGSCheckoutServiceProtocol

	/// Configuration.
	internal let configuration: VGSCheckoutAddCardConfiguration
}

/// Payopt transfers service provider.
internal final class VGSCheckoutPayoptTransfersServiceProvider: VGSCheckoutServiceProviderProtocol {

	// MARK: - Initializer

	/// Initializer.
	/// - Parameter onfiguration: `VGSCheckoutPaymentConfiguration` object, payment configuration.
	/// - Parameter vgsCollect: `VGSCollect` object, an instance of `VGSCollect`.
	/// - Parameter uiTheme: `VGSCheckoutThemeProtocol` object, ui theme.
	init(configuration: VGSCheckoutPaymentConfiguration, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol) {
		self.configuration = configuration
		self.vgsCollect = vgsCollect
		self.uiTheme = uiTheme

		guard let checkoutConfigurationType = VGSCheckoutConfigurationType(configuration: configuration) else {
			fatalError("Invalid configuration for payopt payment service provier!")
		}
		self.checkoutService = VGSCheckoutPayoptTransfersService(checkoutConfigurationType: checkoutConfigurationType, vgsCollect: vgsCollect, uiTheme: uiTheme)
	}

	// MARK: - Vars

	/// VGS collect.
	internal let vgsCollect: VGSCollect

	/// UI Theme.
	internal let uiTheme: VGSCheckoutThemeProtocol

	/// Checkout service.
	internal let checkoutService: VGSCheckoutServiceProtocol

	/// Configuration.
	internal let configuration: VGSCheckoutPaymentConfiguration

//	/// Initial screen.
//	internal let initialScreen: InitialScreen

}

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
		//		self.initialScreen = .payWithNewCard
		switch checkoutConfigurationType {
		case .payoptAddCard(let configuration):
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
//		let saveCardViewController = VGSSaveCardViewController(saveCardService: self)

		// FIXME - add correct view controller.
		return UIViewController()
	}
}
