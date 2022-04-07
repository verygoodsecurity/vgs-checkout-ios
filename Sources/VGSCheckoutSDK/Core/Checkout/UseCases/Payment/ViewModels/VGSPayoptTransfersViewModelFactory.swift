//
//  VGSPayoptTransfersViewModelFactory.swift
//  VGSCheckoutSDK
//

import Foundation

/// Factory for pay opt transfers flow.
internal final class VGSPayoptTransfersViewModelFactory {

	/// Builds pay with new card view model for payopt transders checkout configuration.
	/// - Parameters:
	///   - checkoutService: `VGSCheckoutPayoptTransfersService` object, save card checkout configuration service.
	/// - Returns: `VGSPayoptTransfersPayWithNewCardViewModel` object, pay with new card view model.
	internal static func buildPayWithNewCardViewModel(with checkoutService: VGSPayoptAddCardCheckoutService) ->
	VGSPayoptTransfersPayWithNewCardViewModel {
		return VGSPayoptTransfersPayWithNewCardViewModel(configuration: checkoutService.configuration, vgsCollect: checkoutService.vgsCollect, checkourService: checkoutService)
	}

	/// Builds payment options view model for payopt transders checkout configuration.
	/// - Parameters:
	///   - checkoutService: `VGSSaveCardCheckoutService` object, save card checkout configuration service.
	/// - Returns: `VGSPaymentOptionsViewModel` object, payment options view model.
	internal static func buildPaymentOptionsViewModel(with checkoutService: VGSPayoptAddCardCheckoutService) -> VGSPaymentOptionsViewModel {
		return VGSPaymentOptionsViewModel(configuration: checkoutService.configuration, vgsCollect: checkoutService.vgsCollect, checkoutService: checkoutService)
	}
}
