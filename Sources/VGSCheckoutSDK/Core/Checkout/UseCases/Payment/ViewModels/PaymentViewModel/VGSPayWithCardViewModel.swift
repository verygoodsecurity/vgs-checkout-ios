//
//  VGSPayoptTransfersPayWithNewCardViewModel.swift
//  VGSCheckoutSDK

import Foundation

/// Pay with card component view model for payopt transfers configuration.
internal class VGSPayoptTransfersPayWithNewCardViewModel {

	internal init(configuration: VGSCheckoutPayoptBasicConfiguration, vgsCollect: VGSCollect, checkourService: VGSCheckoutBasicPayoptServiceProtocol) {
		self.configuration = configuration
		self.apiWorker = VGSPayoptAddCardAPIWorker(configuration: configuration, vgsCollect: vgsCollect, checkoutService: checkourService)
	}

	// MARK: - Vars

	/// Configuration.
	private(set) var configuration: VGSCheckoutPayoptBasicConfiguration

	/// Api worker.
  internal let apiWorker: VGSPayoptAddCardAPIWorker

	/// Payment button title.
	internal var submitButtonTitle: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_add_card_button_title")
//		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_pay_with_card_button_title") + " \(formattedAmount)"
	}

	/// Root navigation bar title.
	internal var rootNavigationTitle: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_pay_with_card_navigation_bar_title")
	}

	/// Formatted amount.
//	internal var formattedAmount: String {
//		let paymentInfo = configuration.paymentInfo
//		guard let text = VGSFormatAmountUtils.formatted(amount: paymentInfo.amount, currencyCode: paymentInfo.currency) else {
//			let event = VGSLogEvent(level: .warning, text: "Cannot format amount: \(paymentInfo.amount) currency: \(paymentInfo.currency)", severityLevel: .warning)
//			VGSCheckoutLogger.shared.forwardLogEvent(event)
//			return ""
//		}
//
//		return text
//	}

	/// `true` if user checked saved card option, nil if saved card option is set to false in checkout configuration.
  internal var saveCardCheckboxSelected: Bool?
}
