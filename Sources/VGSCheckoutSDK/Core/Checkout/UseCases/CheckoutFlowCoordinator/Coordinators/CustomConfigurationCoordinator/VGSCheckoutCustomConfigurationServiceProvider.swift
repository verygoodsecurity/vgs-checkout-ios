//
//  VGSCheckoutCustomConfigurationCoordinator.swift
//  VGSCheckoutSDK
//

import Foundation
#if os(iOS)
import UIKit
#endif

/// Custom configuration coordinator.
internal final class VGSCheckoutCustomConfigurationServiceProvider: VGSCheckoutServiceProviderProtocol {

	// MARK: - Initialization

	/// Initializer.
	/// - Parameter customConfiguration: `VGSCheckoutCustomConfiguration` object, configuration.
	/// - Parameter vgsCollect: `VGSCollect` object, an instance of `VGSCollect`.
	/// - Parameter uiTheme: `VGSCheckoutThemeProtocol` object, ui theme.
	init(customConfiguration: VGSCheckoutCustomConfiguration, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol) {
		self.configuration = customConfiguration
		self.vgsCollect = vgsCollect
		self.uiTheme = uiTheme

		guard let checkoutConfigurationType = VGSCheckoutConfigurationType(configuration: customConfiguration) else {
			fatalError("Invalid configuration for custom coordinator!")
		}
		// For custom configuration add card is predefinced hardcoded service.
		self.checkoutService = VGSSaveCardCheckoutService(checkoutConfigurationType: checkoutConfigurationType, vgsCollect: vgsCollect, uiTheme: uiTheme)
	}

	// MARK: - Vars

	/// VGS collect.
	internal let vgsCollect: VGSCollect

	/// Checkout serivce.
	internal let checkoutService: VGSCheckoutServiceProtocol

	/// UI Theme.
	internal let uiTheme: VGSCheckoutThemeProtocol

	/// Configuration.
	internal let configuration: VGSCheckoutCustomConfiguration

	// MARK: - VGSCheckoutFlowCoordinatorProtocol

	/// Builds root view controller.
	/// - Returns: `UIViewController` object, view controller.
	func buildRootViewController() -> UIViewController {
		return checkoutService.buildCheckoutViewController()
	}
}
