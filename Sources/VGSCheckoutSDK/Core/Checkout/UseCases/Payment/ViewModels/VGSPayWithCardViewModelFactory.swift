//
//  VGSPayWithCardViewModelFactory.swift
//  VGSCheckoutSDK
//

import Foundation

/// Factory for pay with card view models.
internal final class VGSPayWithCardViewModelFactory {

	/// Builds add card view model for checkout configuration.
	/// - Parameters:
	///   - checkoutConfigurationType: `VGSCheckoutConfigurationType` object, checkout configuration type.
	///   - vgsCollect: `VGSCollect` object, collect instance.
	/// - Returns: `VGSAddCardViewModelProtocol` object, add card view model.
	internal static func buildAddCardViewModel(with checkoutConfigurationType: VGSCheckoutConfigurationType, vgsCollect: VGSCollect, checkoutService: VGSCheckoutPayoptTransfersService) -> VGSPayoptTransfersPayWithNewCardViewModel {
		switch checkoutConfigurationType {
		case .custom(let customConfiguration):
			fatalError("Invalid flow setup: Custom Add card config is used for payment flow!")
		case .payoptAddCard(let configuration):
			fatalError("Invalid flow setup: PayOpt Add card config is used for payment flow!")
		case .payoptTransfers(let configuration):
			return VGSPayoptTransfersPayWithNewCardViewModel(configuration: configuration, vgsCollect: vgsCollect, checkourService: checkoutService)
		}
	}

	/// Builds payment options view model for checkout configuration.
	/// - Parameters:
	///   - checkoutConfigurationType: `VGSCheckoutConfigurationType` object, checkout configuration type.
	///   - vgsCollect: `VGSCollect` object, collect instance.
	/// - Returns: `VGSPaymentOptionsViewModel` object, payment options view model.
	internal static func buildPaymentOptionsViewModel(with checkoutConfigurationType: VGSCheckoutConfigurationType, vgsCollect: VGSCollect, checkoutService: VGSCheckoutPayoptTransfersService) -> VGSPaymentOptionsViewModel {
		switch checkoutConfigurationType {
		case .custom(let customConfiguration):
			fatalError("Invalid flow setup: Custom Add card config is used for payment flow!")
		case .payoptAddCard(let configuration):
			fatalError("Invalid flow setup: Pay Opt Add card config is used for payment flow!")
		case .payoptTransfers(let configuration):
			return VGSPaymentOptionsViewModel(configuration: configuration, vgsCollect: vgsCollect, checkoutService: checkoutService)
		}
	}
}
