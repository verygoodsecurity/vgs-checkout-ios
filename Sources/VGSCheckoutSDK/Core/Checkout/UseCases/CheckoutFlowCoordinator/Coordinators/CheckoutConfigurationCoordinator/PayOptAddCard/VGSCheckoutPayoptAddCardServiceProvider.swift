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
