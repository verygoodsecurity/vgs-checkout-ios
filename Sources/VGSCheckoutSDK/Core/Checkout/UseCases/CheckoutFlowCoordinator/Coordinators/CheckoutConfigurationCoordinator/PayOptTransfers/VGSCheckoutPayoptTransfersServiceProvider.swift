//
//  VGSCheckoutPayoptTransfersServiceProvider.swift
//  VGSCheckoutSDK

import Foundation

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
