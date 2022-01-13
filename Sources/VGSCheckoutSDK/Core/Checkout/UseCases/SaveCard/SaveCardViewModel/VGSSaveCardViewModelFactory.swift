//
//  VGSSaveCardViewModelFactory.swift
//  VGSCheckoutSDK
//

import Foundation

/// Factory for add card view models.
internal final class VGSSaveCardViewModelFactory {

	/// Builds add card view model for checkout configuration.
	/// - Parameters:
	///   - checkoutConfigurationType: `VGSCheckoutConfigurationType` object, checkout configuration type.
	///   - vgsCollect: `VGSCollect` object, collect instance.
	/// - Returns: `VGSAddCardViewModelProtocol` object, add card view model.
	internal static func buildAddCardViewModel(with checkoutConfigurationType: VGSCheckoutConfigurationType, vgsCollect: VGSCollect) -> VGSSaveCardViewModelProtocol {
		switch checkoutConfigurationType {
		case .custom(let customConfiguration):
			return VGSSaveCardCustomViewModel(customConfiguration: customConfiguration, vgsCollect: vgsCollect)
		case .payoptAddCard(let configuration):
			return VGSPayoptAddCardViewModel(configuration: configuration, vgsCollect: vgsCollect)
		case .payoptTransfers:
			fatalError("Invalid flow setup: Payment config is used in add card!")
		}
	}
}
