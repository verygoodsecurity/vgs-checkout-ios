//
//  VGSPayoptTransfersViewModelFactory.swift
//  VGSCheckoutSDK
//

import Foundation

/// Factory for pay with card view models.
internal final class VGSPayoptTransfersViewModelFactory {

	/// Builds pay with new card view model for payopt transders checkout configuration.
	/// - Parameters:
	///   - checkoutService: `VGSCheckoutPayoptTransfersService` object, payopt checkout configuration service.
	/// - Returns: `VGSPayoptTransfersPayWithNewCardViewModel` object, pay with new card view model.
	internal static func buildPayWithNewCardViewModel(with checkoutService: VGSCheckoutPayoptTransfersService) ->
	VGSPayoptTransfersPayWithNewCardViewModel {
		switch checkoutService.checkoutConfigurationType {
		case .custom:
			fatalError("Invalid flow setup: Custom Add card config is used for payment flow!")
		case .payoptAddCard:
			fatalError("Invalid flow setup: PayOpt Add card config is used for payment flow!")
		case .payoptTransfers(let configuration):
			return VGSPayoptTransfersPayWithNewCardViewModel(configuration: configuration, vgsCollect: checkoutService.vgsCollect, checkourService: checkoutService)
		}
	}

	/// Builds payment options view model for payopt transders checkout configuration.
	/// - Parameters:
	///   - checkoutService: `VGSCheckoutPayoptTransfersService` object, payopt checkout configuration service.
	///   - vgsCollect: `VGSCollect` object, collect instance.
	/// - Returns: `VGSPaymentOptionsViewModel` object, payment options view model.
	internal static func buildPaymentOptionsViewModel(with checkoutService: VGSCheckoutPayoptTransfersService) -> VGSPaymentOptionsViewModel {
		switch checkoutService.checkoutConfigurationType {
		case .custom:
			fatalError("Invalid flow setup: Custom Add card config is used for payment flow!")
		case .payoptAddCard:
			fatalError("Invalid flow setup: Pay Opt Add card config is used for payment flow!")
		case .payoptTransfers(let configuration):
			return VGSPaymentOptionsViewModel(configuration: configuration, vgsCollect: checkoutService.vgsCollect, checkoutService: checkoutService)
		}
	}
}
