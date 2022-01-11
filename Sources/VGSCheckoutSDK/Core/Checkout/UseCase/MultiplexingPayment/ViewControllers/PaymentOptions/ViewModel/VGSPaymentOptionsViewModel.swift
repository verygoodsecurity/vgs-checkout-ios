//
//  VGSPaymentOptionsViewModel.swift
//  VGSCheckoutSDK


import Foundation

/// Payment options component view model for multiplexing configuration.
internal class VGSPaymentOptionsViewModel {

	internal var previsouslySelectedID: String? = nil

	internal init(multiplexingConfiguration: VGSCheckoutMultiplexingPaymentConfiguration, vgsCollect: VGSCollect) {
		self.multiplexingConfiguration = multiplexingConfiguration
		self.apiWorker = VGSMultiplexingPaymentsAPIWorker(multiplexingConfiguration: multiplexingConfiguration, vgsCollect: vgsCollect)

		/// Preselect first card.
		let firstPaymentOption = paymentOptions[0]
			switch firstPaymentOption {
			case .savedCard(let card):
				var firstSavedCard = card
				firstSavedCard.isSelected = true
				paymentOptions[0] = .savedCard(firstSavedCard)
				self.previsouslySelectedID = card.id
			default:
				break
		}
	}

	// MARK: - Vars

	/// An array of payment options.
	internal var paymentOptions: [VGSPaymentOption] = [
		.savedCard(VGSSavedCardModel(id: "1", cardBrand: "visa", last4: "1234", expDate: "12/22", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "2", cardBrand: "maestro", last4: "5678", expDate: "01/23", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "3", cardBrand: "visa", last4: "1234", expDate: "12/22", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "4", cardBrand: "maestro", last4: "5678", expDate: "01/23", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "5", cardBrand: "visa", last4: "1234", expDate: "12/22", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "6", cardBrand: "maestro", last4: "5678", expDate: "01/23", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "7", cardBrand: "visa", last4: "1234", expDate: "12/22", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "8", cardBrand: "maestro", last4: "5678", expDate: "01/23", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "9", cardBrand: "visa", last4: "1234", expDate: "12/22", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "10", cardBrand: "maestro", last4: "5678", expDate: "01/23", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "11", cardBrand: "visa", last4: "1234", expDate: "12/22", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "12", cardBrand: "maestro", last4: "5678", expDate: "01/23", cardHolder: "John Smith")),
		.newCard
	]

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
