//
//  VGSCheckoutMultiplexingConfigurationCoordinator.swift
//  VGSCheckoutSDK
//

import Foundation
#if os(iOS)
import UIKit
#endif

/// Multiplexing coordinator.
internal final class VGSCheckoutMultiplexingAddCardServiceProvider: VGSCheckoutServiceProviderProtocol {

	// MARK: - Initializer

	/// Initializer.
	/// - Parameter multiplexingConfiguration: `VGSCheckoutMultiplexingConfiguration` object, multiplexing configuration.
	/// - Parameter vgsCollect: `VGSCollect` object, an instance of `VGSCollect`.
	/// - Parameter uiTheme: `VGSCheckoutThemeProtocol` object, ui theme.
	init(multiplexingConfiguration: VGSCheckoutMultiplexingAddCardConfiguration, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol) {
		self.multiplexingConfiguration = multiplexingConfiguration
		self.vgsCollect = vgsCollect
		self.uiTheme = uiTheme

		guard let checkoutConfigurationType = VGSCheckoutConfigurationType(configuration: multiplexingConfiguration) else {
			fatalError("Invalid configuration for multiplexing service provier!")
		}
		self.checkoutService = VGSSaveCardCheckoutService(checkoutConfigurationType: checkoutConfigurationType, vgsCollect: vgsCollect, uiTheme: uiTheme)
	}

	// MARK: - Vars

	/// VGS collect.
	internal let vgsCollect: VGSCollect

	/// UI Theme.
	internal let uiTheme: VGSCheckoutThemeProtocol

	/// Checkout service.
	internal let checkoutService: VGSCheckoutServiceProtocol

	/// Multiplexing configuration.
	internal let multiplexingConfiguration: VGSCheckoutMultiplexingAddCardConfiguration
}

/// Multiplexing coordinator.
internal final class VGSCheckoutMultiplexingPaymentServiceProvider: VGSCheckoutServiceProviderProtocol {

	// MARK: - Initializer

	/// Initializer.
	/// - Parameter multiplexingConfiguration: `VGSCheckoutMultiplexingPaymentConfiguration` object, multiplexing configuration.
	/// - Parameter vgsCollect: `VGSCollect` object, an instance of `VGSCollect`.
	/// - Parameter uiTheme: `VGSCheckoutThemeProtocol` object, ui theme.
	init(multiplexingConfiguration: VGSCheckoutMultiplexingPaymentConfiguration, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol) {
		self.multiplexingConfiguration = multiplexingConfiguration
		self.vgsCollect = vgsCollect
		self.uiTheme = uiTheme

		guard let checkoutConfigurationType = VGSCheckoutConfigurationType(configuration: multiplexingConfiguration) else {
			fatalError("Invalid configuration for multiplexing service provier!")
		}
		self.checkoutService = VGSCheckoutPaymentService(checkoutConfigurationType: checkoutConfigurationType, vgsCollect: vgsCollect, uiTheme: uiTheme)
	}

	// MARK: - Vars

	/// VGS collect.
	internal let vgsCollect: VGSCollect

	/// UI Theme.
	internal let uiTheme: VGSCheckoutThemeProtocol

	/// Checkout service.
	internal let checkoutService: VGSCheckoutServiceProtocol

	/// Multiplexing configuration.
	internal let multiplexingConfiguration: VGSCheckoutMultiplexingPaymentConfiguration
}
