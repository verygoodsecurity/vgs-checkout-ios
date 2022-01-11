//
//  VGSMultiplexingPayWithCardViewModel.swift
//  VGSCheckoutSDK

import Foundation

/// Pay with card component view model for multiplexing configuration.
internal class VGSMultiplexingPayWithCardViewModel {

	internal init(multiplexingConfiguration: VGSCheckoutMultiplexingPaymentConfiguration, vgsCollect: VGSCollect) {
		self.multiplexingConfiguration = multiplexingConfiguration
		self.apiWorker = VGSMultiplexingPaymentsAPIWorker(multiplexingConfiguration: multiplexingConfiguration, vgsCollect: vgsCollect)
	}

	// MARK: - Vars

	/// Configuration.
	private(set) var multiplexingConfiguration: VGSCheckoutMultiplexingPaymentConfiguration

	let apiWorker: VGSMultiplexingPaymentsAPIWorker

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
		let paymentInfo = multiplexingConfiguration.paymentInfo
		guard let text = VGSFormatAmountUtils.formatted(amount: paymentInfo.amount, currencyCode: paymentInfo.currency) else {
			let event = VGSLogEvent(level: .warning, text: "Cannot format amount: \(paymentInfo.amount) currency: \(paymentInfo.currency)", severityLevel: .warning)
			VGSCheckoutLogger.shared.forwardLogEvent(event)
			return ""
		}

		return text
	}
  
  internal var saveCardCheckboxSelected: Bool = true
}
