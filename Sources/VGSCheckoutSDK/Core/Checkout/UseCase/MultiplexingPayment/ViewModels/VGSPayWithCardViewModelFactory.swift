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
	internal static func buildAddCardViewModel(with checkoutConfigurationType: VGSCheckoutConfigurationType, vgsCollect: VGSCollect) -> VGSMultiplexingPayWithCardViewModel {
		switch checkoutConfigurationType {
		case .custom(let customConfiguration):
			fatalError("Invalid flow setup: Custom Add card config is used for payment flow!")
		case .multiplexingAddCard(let multiplexingConfiguration):
			fatalError("Invalid flow setup: Multiplexing Add card config is used for payment flow!")
		case .multiplexingPayment(let multiplexingConfiguration):
			return VGSMultiplexingPayWithCardViewModel(multiplexingConfiguration: multiplexingConfiguration, vgsCollect: vgsCollect)
		}
	}

	/// Builds payment options view model for checkout configuration.
	/// - Parameters:
	///   - checkoutConfigurationType: `VGSCheckoutConfigurationType` object, checkout configuration type.
	///   - vgsCollect: `VGSCollect` object, collect instance.
	/// - Returns: `VGSPaymentOptionsViewModel` object, payment options view model.
	internal static func buildPaymentOptionsViewModel(with checkoutConfigurationType: VGSCheckoutConfigurationType, vgsCollect: VGSCollect) -> VGSPaymentOptionsViewModel {
		switch checkoutConfigurationType {
		case .custom(let customConfiguration):
			fatalError("Invalid flow setup: Custom Add card config is used for payment flow!")
		case .multiplexingAddCard(let multiplexingConfiguration):
			fatalError("Invalid flow setup: Multiplexing Add card config is used for payment flow!")
		case .multiplexingPayment(let multiplexingConfiguration):
			return VGSPaymentOptionsViewModel(multiplexingConfiguration: multiplexingConfiguration, vgsCollect: vgsCollect)
		}
	}
}
