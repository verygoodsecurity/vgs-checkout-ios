//
//  VGSPaymentOptionsViewModel.swift
//  VGSCheckoutSDK

import Foundation

internal protocol VGSPaymentOptionsViewModelDelegate: AnyObject {
	func savedCardSelectionDidUpdate()
	func savedCardDidUpdateForEditing()
	func savedCardDidRemove(with id: String)
	func payWithNewCardDidTap()
}

/// Payment options component view model for payopt transfers configuration.
internal class VGSPaymentOptionsViewModel {

	/// An object that acts as a view model delegate.
	internal weak var delegate: VGSPaymentOptionsViewModelDelegate?

	/// Last selected card saved card id.
	internal var lastSelectedSavedCardId: String?

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

		/// Preselect first card by default.
		paymentOptions.preselectFirstSavedCard()
		if let id = paymentOptions.first?.savedCardModel?.id {
			self.lastSelectedSavedCardId = id
		}
	}

	// MARK: - Vars

	/// An array of payment options.
	internal var paymentOptions: [VGSPaymentOption] = provideMockedData()

	/// Configuration.
	private(set) var configuration: VGSCheckoutPaymentConfiguration

	/// Transfers API worker.
	internal let apiWorker: VGSPayoptTransfersAPIWorker

	/// Payment button title.
	internal var submitButtonTitle: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_pay_with_card_button_title") + " \(formattedAmount)"
	}

	/// Navigation bar title.
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

	internal func handlePaymentOptionTap(at index: Int) {
		guard let paymentOption = paymentOptions[safe: index] else {
			assertionFailure("payment option not found at index: \(index)")
			return
		}

		switch paymentOption {
		case.savedCard(var savedCard):
			guard let lastSelectedId = lastSelectedSavedCardId else {return}

			/// Ignore same card selection.
			if savedCard.id == lastSelectedId {
				return
			} else {
				// Select new card.
				savedCard.isSelected = true
				paymentOptions[index] = .savedCard(savedCard)

				// Remove selection from the last selected card.
				for index in 0..<paymentOptions.count {
					let option = paymentOptions[index]
					switch option {
					case .savedCard(var card):
						if card.id == lastSelectedId {
							card.isSelected = false
							paymentOptions[index] = .savedCard(card)
						}
					case .newCard:
						continue
					}
				}
			}

			// Save new selected id.
			lastSelectedSavedCardId = savedCard.id
			delegate?.savedCardSelectionDidUpdate()
		case .newCard:
			delegate?.payWithNewCardDidTap()
		}
	}

	internal func savedCardModel(at index: Int) -> VGSSavedCardModel? {
		return paymentOptions[safe: index]?.savedCardModel
	}

	internal func handleEditModeTap() {
		paymentOptions.unselectAllSavedCards()
		delegate?.savedCardDidUpdateForEditing()
	}

	internal func hadleRemoveSavedCard(with cardIdToRemove: String) {
		paymentOptions.removeSavedCard(with: cardIdToRemove)
		if lastSelectedSavedCardId == cardIdToRemove {
			lastSelectedSavedCardId = nil
		}
		delegate?.savedCardDidRemove(with: cardIdToRemove)
	}

	/// Selected payment card info.
	internal var selectedPaymentCardInfo: VGSCheckoutPaymentCardInfo? {
		guard let selectedId = lastSelectedSavedCardId else {return nil}
		let savedCardModels = paymentOptions.compactMap { paymentOption -> VGSSavedCardModel? in
			switch paymentOption {
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
