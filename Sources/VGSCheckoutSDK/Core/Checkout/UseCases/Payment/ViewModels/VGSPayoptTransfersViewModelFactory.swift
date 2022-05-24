//
//  VGSPayoptTransfersViewModelFactory.swift
//  VGSCheckoutSDK
//

import Foundation

/// Factory for pay opt transfers flow.
internal final class VGSPayoptTransfersViewModelFactory {

	/// Builds pay with new card view model for payopt transders checkout configuration.
	/// - Parameters:
	///   - checkoutService: `VGSCheckoutBasicPayoptServiceProtocol` object, basic payopt checkout service.
	/// - Returns: `VGSPayoptTransfersPayWithNewCardViewModel` object, pay with new card view model.
	internal static func buildPayWithNewCardViewModel(with checkoutService: VGSCheckoutBasicPayoptServiceProtocol) ->
	VGSPayoptTransfersPayWithNewCardViewModel {
		return VGSPayoptTransfersPayWithNewCardViewModel(configuration: checkoutService.configuration, vgsCollect: checkoutService.configuration.vgsCollect, checkourService: checkoutService)
	}

	/// Builds payment options view model for payopt transders checkout configuration.
	/// - Parameters:
	///   - checkoutService: `VGSSaveCardCheckoutService` object, save card checkout configuration service.
	/// - Returns: `VGSPaymentOptionsViewModel` object, payment options view model.
	internal static func buildPaymentOptionsViewModel(with checkoutService: VGSCheckoutBasicPayoptServiceProtocol) -> VGSPaymentOptionsViewModel {
		return VGSPaymentOptionsViewModel(configuration: checkoutService.configuration, vgsCollect: checkoutService.configuration.vgsCollect, checkoutService: checkoutService)
	}
}
