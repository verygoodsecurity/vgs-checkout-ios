//
//  VGSPayoptTransfersPayWithNewCardViewModel.swift
//  VGSCheckoutSDK

import Foundation

/// Pay with card component view model for payopt transfers configuration.
internal class VGSPayoptTransfersPayWithNewCardViewModel {

	internal init(configuration: VGSCheckoutPaymentConfiguration, vgsCollect: VGSCollect) {
		self.configuration = configuration
		self.apiWorker = VGSPayoptTransfersAPIWorker(configuration: configuration, vgsCollect: vgsCollect)
	}

	// MARK: - Vars

	/// Configuration.
	private(set) var configuration: VGSCheckoutPaymentConfiguration

	/// Api worker.
	internal let apiWorker: VGSPayoptTransfersAPIWorker

	/// Payment button title.
	internal var submitButtonTitle: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_pay_with_card_button_title") + " \(formattedAmount)"
	}

	/// Root navigation bar title.
	internal var rootNavigationTitle: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_pay_with_card_navigation_bar_title")
	}

	/// Formatted amount.
	internal var formattedAmount: String {
		let paymentInfo = configuration.paymentInfo
		guard let text = VGSFormatAmountUtils.formatted(amount: paymentInfo.amount, currencyCode: paymentInfo.currency) else {
			let event = VGSLogEvent(level: .warning, text: "Cannot format amount: \(paymentInfo.amount) currency: \(paymentInfo.currency)", severityLevel: .warning)
			VGSCheckoutLogger.shared.forwardLogEvent(event)
			return ""
		}

		return text
	}
  
  internal var saveCardCheckboxSelected: Bool = true
}