//
//  VGSPaymentOptionsViewModel.swift
//  VGSCheckoutSDK

import Foundation

/// Payment options component view model for payopt transfers configuration.
internal class VGSPaymentOptionsViewModel {

	/// Last selected card saved card id.
	internal var previsouslySelectedID: String?

	/// Initializer.
	/// - Parameters:
	///   - configuration: `VGSCheckoutPaymentConfiguration`, payment configuration.
	///   - vgsCollect: `VGSCollect` object, vgs collect.
	///   - checkoutService: `VGSCheckoutPayoptTransfersService` object, payopt transfers service.
	internal init(configuration: VGSCheckoutPaymentConfiguration, vgsCollect: VGSCollect, checkoutService: VGSCheckoutPayoptTransfersService) {
		self.configuration = configuration
		self.apiWorker = VGSPayoptTransfersAPIWorker(configuration: configuration, vgsCollect: vgsCollect, checkoutService: checkoutService)
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
		.savedCard(VGSSavedCardModel(id: "3", cardBrand: "visa", last4: "1234", expDate: "12/24", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "4", cardBrand: "maestro", last4: "5678", expDate: "01/25", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "5", cardBrand: "visa", last4: "1234", expDate: "12/26", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "6", cardBrand: "maestro", last4: "5678", expDate: "01/27", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "7", cardBrand: "visa", last4: "1234", expDate: "12/28", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "8", cardBrand: "maestro", last4: "5678", expDate: "01/29", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "9", cardBrand: "visa", last4: "1234", expDate: "12/30", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "10", cardBrand: "maestro", last4: "5678", expDate: "01/31", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "11", cardBrand: "visa", last4: "1234", expDate: "12/32", cardHolder: "John Smith")),
		.savedCard(VGSSavedCardModel(id: "12", cardBrand: "maestro", last4: "5678", expDate: "01/33", cardHolder: "John Smith")),
		.newCard
	]

	/// Configuration.
	private(set) var configuration: VGSCheckoutPaymentConfiguration

	/// Transfers API worker.
	internal let apiWorker: VGSPayoptTransfersAPIWorker

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
		guard savedCardModels.first(where: {$0.id == selectedId}) != nil else {return nil}
		return VGSCheckoutPaymentCardInfo(id: selectedId)
	}
}
