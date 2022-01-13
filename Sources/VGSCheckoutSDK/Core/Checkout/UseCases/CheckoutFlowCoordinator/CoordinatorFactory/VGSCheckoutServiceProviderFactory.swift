//
//  VGSCheckoutServiceProviderFactory.swift
//  VGSCheckoutSDK

import Foundation

/// Factory for checkout coordinators.
internal class VGSCheckoutServiceProviderFactory {

	/// Builds checkout service provider for payment instrument.
	/// - Parameter checkoutConfigurationType: `VGScheckoutConfigurationType` object, payment instrument.
	/// - Parameter vgsCollect: `VGSCollect` object, an instance of `VGSCollect`.
	/// - Parameter uiTheme: `VGSCheckoutThemeProtocol` object, ui theme.
	/// - Returns: `VGSCheckoutFlowCoordinatorProtocol` object, coordinator.
	static func buildCheckoutServiceProvider(with checkoutConfigurationType: VGSCheckoutConfigurationType, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol) -> VGSCheckoutServiceProviderProtocol {
		switch checkoutConfigurationType {
		case .custom(let configuration):
			return VGSCheckoutCustomConfigurationServiceProvider(customConfiguration: configuration, vgsCollect: vgsCollect, uiTheme: uiTheme)
		case .payoptAddCard(let configuration):
			return VGSCheckoutPayoptAddCardServiceProvider(configuration: configuration, vgsCollect: vgsCollect, uiTheme: uiTheme)
		case .payoptTransfers(let configuration):
			return VGSCheckoutPayoptTransfersServiceProvider(configuration: configuration, vgsCollect: vgsCollect, uiTheme: uiTheme)
		}
	}
}
