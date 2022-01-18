//
//  VGSPaymentOptionsViewModel.swift
//  VGSCheckoutSDK


import Foundation

/// Payment options component view model for payopt transfers configuration.
internal class VGSPaymentOptionsViewModel {

	internal var previsouslySelectedID: String?

	internal init(configuration: VGSCheckoutPaymentConfiguration, vgsCollect: VGSCollect) {
		self.configuration = configuration
		self.apiWorker = VGSPayoptTransfersAPIWorker(configuration: configuration, vgsCollect: vgsCollect)
		let savedCards = configuration.savedCards
		let savedCardsOptions = savedCards.map({return VGSPaymentOption.savedCard($0)})

//		self.paymentOptions = savedCardsOptions
//		self.paymentOptions.append(.newCard)

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
		.savedCard(VGSSavedCardModel(id: "1", cardBrand: "visa", last4: "1234", expDate: "12/22", cardHolder: "John Smith Smith Smith Smith Smith Smith M")),
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
	private(set) var configuration: VGSCheckoutPaymentConfiguration

	let apiWorker: VGSPayoptTransfersAPIWorker

	/// Payment button title.
	internal var submitButtonTitle: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_pay_with_card_button_title") + " \(formattedAmount)"
	}

	/// Root navigation bar title.
	internal var rootNavigationTitle: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_payment_options_navigation_bar_title")
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

	/// Selected payment card info.
	internal var selectedPaymentCardInfo: VGSCheckoutPaymentCardInfo? {
		guard let selectedId = previsouslySelectedID else {return nil}
		let savedCardModels = paymentOptions.compactMap { option -> VGSSavedCardModel? in
			switch option {
			case .savedCard(let card):
				return card
			case .newCard:
				return nil
			}
		}
		guard let firstModel = savedCardModels.first(where: {$0.id == selectedId}) else {return nil}
		return VGSCheckoutPaymentCardInfo(id: selectedId)
	}

	internal var saveCardCheckboxSelected: Bool = true
}
